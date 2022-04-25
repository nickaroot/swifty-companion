//
//  BearerAuthenticator.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Alamofire
import Foundation

public class BearerAuthenticator: Authenticator {
    public typealias Credential = Bearer

    // MARK: - Refresh Token Closure

    public typealias RefreshTokenClosure = ((String) async throws -> Bearer)

    public var refreshToken: RefreshTokenClosure

    // MARK: - Init

    public init(
        refreshToken: @escaping RefreshTokenClosure
    ) {
        self.refreshToken = refreshToken
    }

    // MARK: - Authenticator

    public func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.setValue("Bearer " + credential.accessToken, forHTTPHeaderField: "Authorization")
    }

    public func refresh(
        _ credential: Credential,
        for session: Session,
        completion: @escaping (Result<Credential, Error>) -> Void
    ) {
        Task {
            do {
                let bearer = try await refreshToken(credential.refreshToken)

                completion(.success(bearer))
            } catch let error {
                completion(.failure(error))
            }
        }
    }

    public func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: Error
    ) -> Bool {
        true
    }

    public func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: Credential
    ) -> Bool {
        urlRequest.headers.contains { header in
            header.name == "Authorization" && header.value == "Bearer " + credential.accessToken
        }
    }

}

public typealias BearerInterceptor = AuthenticationInterceptor<BearerAuthenticator>
