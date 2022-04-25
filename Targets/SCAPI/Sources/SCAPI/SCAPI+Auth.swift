//
//  SCAPI+Auth.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 17.04.2022.
//

import Alamofire
import AsyncDisplayKit
import AuthenticationServices
import CloudKit
import Security

protocol SCAPIAuthOutput: AnyObject {
    var baseURL: URL? { get }

    var session: Session { get }

    var authenticationInterceptor: BearerInterceptor { get }
}

extension SCAPI {
    // MARK: - Auth

    public class Auth {
        weak var api: SCAPIAuthOutput!

        // MARK: - Secrets

        lazy var state = UUID().uuidString

        var secrets: (scheme: String, clientID: String, clientSecret: String) {
            get async throws {
                let publicDB = CKContainer.default().publicCloudDatabase

                let predicate = NSPredicate(value: true)
                let query = CKQuery(recordType: "API", predicate: predicate)

                let records = try await publicDB.records(matching: query)

                guard let result = records.matchResults.first else {
                    throw .api.auth(.invalidSecrets)
                }

                guard case let .success(record) = result.1 else {
                    if case let .failure(error) = result.1 {
                        throw error
                    }

                    throw .api.auth(.invalidSecrets)
                }

                guard
                    let scheme = record.value(forKey: "scheme") as? String,
                    let clientID = record.value(forKey: "client_id") as? String,
                    let clientSecret = record.value(forKey: "client_secret") as? String
                else {
                    throw .api.auth(.invalidSecrets)
                }

                return (scheme: scheme, clientID: clientID, clientSecret: clientSecret)
            }
        }

        func updateKeychain(withBearer bearer: Bearer) throws {
            let bearerData = try JSONEncoder().encode(bearer)

            let updateQuery =
                [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrService as String: "SwiftyCompanion",
                ] as CFDictionary

            let updateAttributes =
                [
                    kSecAttrService as String: "SwiftyCompanion",
                    kSecValueData as String: bearerData,
                ] as CFDictionary

            let updateStatus = SecItemUpdate(updateQuery, updateAttributes)

            guard updateStatus != errSecItemNotFound else {
                let addQuery =
                    [
                        kSecClass as String: kSecClassGenericPassword,
                        kSecAttrService as String: "SwiftyCompanion",
                        kSecValueData as String: bearerData,
                    ] as CFDictionary

                let addStatus = SecItemAdd(addQuery, nil)

                guard addStatus == errSecSuccess else {
                    throw .api.keychain(.unableToAdd)
                }

                return
            }

            guard updateStatus == errSecSuccess else {
                throw .api.keychain(.unableToUpdate)
            }
        }

        var keychainToken: Bearer? {
            get {
                let getQuery =
                    [
                        kSecClass as String: kSecClassGenericPassword,
                        kSecAttrService as String: "SwiftyCompanion",
                        kSecReturnData as String: true,
                    ] as CFDictionary

                var getItem: CFTypeRef?

                let getStatus = SecItemCopyMatching(getQuery, &getItem)

                guard getStatus == errSecSuccess,
                    let bearerData = getItem as? Data,
                    let bearer = try? JSONDecoder().decode(Bearer.self, from: bearerData)
                else {
                    return nil
                }

                return bearer
            }

            set(bearer) {
                guard let bearer = bearer else {
                    let deleteQuery =
                        [
                            kSecClass as String: kSecClassGenericPassword,
                            kSecAttrService as String: "SwiftyCompanion",
                        ] as CFDictionary

                    let deleteStatus = SecItemDelete(deleteQuery)

                    guard deleteStatus == errSecSuccess else { return }

                    return
                }

                try? updateKeychain(withBearer: bearer)
            }
        }

        // MARK: - Authorize

        public var authorizeURL: URL? {
            URL(
                string: "/oauth/authorize",
                relativeTo: api.baseURL
            )
        }

        struct CodeParameters: Encodable {
            enum ResponseType: String, Encodable {
                case code
            }

            enum Scope: String, Encodable {
                case `public`
            }

            let clientID: String
            let redirectURI: String
            let scope: String
            let state: String
            let responseType: ResponseType

            enum CodingKeys: String, CodingKey {
                case clientID = "client_id"
                case redirectURI = "redirect_uri"
                case scope = "scope"
                case state = "state"
                case responseType = "response_type"
            }

            init(
                clientID: String,
                redirectURI: String,
                scope: [Scope],
                state: String,
                responseType: ResponseType
            ) {
                self.clientID = clientID
                self.redirectURI = redirectURI
                self.scope = scope.map { $0.rawValue }.joined(separator: ",")
                self.state = state
                self.responseType = responseType
            }
        }

        public var codeCallback: (scheme: String, url: URL) {
            get async throws {
                guard let authorizeURL = authorizeURL else { throw .api.invalidURL }

                let (scheme, clientID, _) = try await secrets

                let parameters = CodeParameters(
                    clientID: clientID,
                    redirectURI: "\(scheme)://auth",
                    scope: [.public],
                    state: state,
                    responseType: .code
                )

                let request = AF.request(authorizeURL, method: .get, parameters: parameters)

                guard let url = request.convertible.urlRequest?.url else {
                    throw .api.invalidRequest
                }

                return (scheme: scheme, url: url)
            }
        }

        public func codeCallbackHandler(
            _ continuation: (CheckedContinuation<URL, Error>)
        ) -> ASWebAuthenticationSession.CompletionHandler {
            { callbackURL, error in
                continuation.resume(
                    with: Result(catching: {
                        guard let callbackURL = callbackURL else {
                            if let error = error {
                                throw error
                            }

                            throw .api.invalidResponse
                        }

                        return callbackURL
                    })
                )
            }
        }

        public func code(fromURL callbackURL: URL) throws -> String {
            guard
                let urlComponents = URLComponents(string: callbackURL.absoluteString),
                let queryItems = urlComponents.queryItems,
                let code = queryItems.first(where: { $0.name == "code" })?.value
            else {
                throw .api.auth(.invalidCode)
            }

            return code
        }

        // MARK: - Token

        public var tokenURL: URL? {
            URL(
                string: "/oauth/token",
                relativeTo: api.baseURL
            )
        }

        struct TokenParameters: Encodable {
            enum GrantType: String, Encodable {
                case authorizationCode = "authorization_code"
                case refreshToken = "refresh_token"
            }

            let grantType: GrantType
            let clientID: String
            let clientSecret: String
            let redirectURI: String
            let code: String?
            let state: String?
            let refreshToken: String?

            enum CodingKeys: String, CodingKey {
                case grantType = "grant_type"
                case clientID = "client_id"
                case clientSecret = "client_secret"
                case redirectURI = "redirect_uri"
                case code = "code"
                case state = "state"
                case refreshToken = "refresh_token"
            }

            init(
                clientID: String,
                clientSecret: String,
                redirectURI: String,
                code: String,
                state: String
            ) {
                self.grantType = .authorizationCode
                self.clientID = clientID
                self.clientSecret = clientSecret
                self.redirectURI = redirectURI
                self.code = code
                self.state = state
                self.refreshToken = nil
            }

            init(
                clientID: String,
                clientSecret: String,
                redirectURI: String,
                refreshToken: String
            ) {
                self.grantType = .refreshToken
                self.clientID = clientID
                self.clientSecret = clientSecret
                self.redirectURI = redirectURI
                self.code = nil
                self.state = nil
                self.refreshToken = refreshToken
            }
        }

        public func token(forCode code: String) async throws -> Bearer {
            guard let tokenURL = tokenURL else { throw .api.invalidURL }

            let (scheme, clientID, clientSecret) = try await secrets

            let parameters = TokenParameters(
                clientID: clientID,
                clientSecret: clientSecret,
                redirectURI: "\(scheme)://auth",
                code: code,
                state: state
            )

            let request = AF.request(tokenURL, method: .post, parameters: parameters)

            let bearer: Bearer = try await request.serializingDecodable().value

            try updateKeychain(withBearer: bearer)

            api.authenticationInterceptor.credential = bearer

            return bearer
        }

        // MARK: - Token Refresh

        public func refreshToken(_ refreshToken: String) async throws -> Bearer {
            guard let tokenURL = tokenURL else { throw .api.invalidURL }

            let (scheme, clientID, clientSecret) = try await secrets

            let parameters = TokenParameters(
                clientID: clientID,
                clientSecret: clientSecret,
                redirectURI: "\(scheme)://auth",
                refreshToken: refreshToken
            )

            let request = AF.request(tokenURL, method: .post, parameters: parameters)

            guard let bearer: Bearer = try? await request.serializingDecodable().value else {
                keychainToken = nil

                throw .api.auth(.invalidRefresh)
            }

            try updateKeychain(withBearer: bearer)

            return bearer
        }

        // MARK: -  Token Info

        public var tokenInfoURL: URL? {
            URL(
                string: "/oauth/token/info",
                relativeTo: api.baseURL
            )
        }

        public func tokenInfo() async throws -> String {
            guard let tokenInfoURL = tokenInfoURL else { throw .api.invalidURL }

            let request = api.session.request(tokenInfoURL, method: .get)

            return try await request.serializingString().value
        }

        // MARK: - Init

        init() {}
    }
}
