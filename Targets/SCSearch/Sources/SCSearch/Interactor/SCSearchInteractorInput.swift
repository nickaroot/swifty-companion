//
//  SCSearchInteractorInput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import AuthenticationServices
import SCAPI
import SCUI

public protocol SCSearchInteractorInput: SCInteractorInputProtocol {
    var authCode: String { get async throws }

    func authToken(forCode code: String) async throws -> Bearer

    func me() async throws -> User

    var isAuthorized: Bool { get }

    func users(_ query: String) async throws -> [BasicUser]
}

extension SCSearchInteractor: SCSearchInteractorInput {
    public var authCode: String {
        get async throws {
            let (scheme, url) = try await api.auth.codeCallback

            let callbackURL: URL = try await withCheckedThrowingContinuation { continuation in
                let session = ASWebAuthenticationSession(
                    url: url,
                    callbackURLScheme: scheme,
                    completionHandler: api.auth.codeCallbackHandler(continuation)
                )

                session.presentationContextProvider = presenter

                DispatchQueue.main.async {
                    guard session.canStart else { return }

                    session.start()
                }
            }

            return try api.auth.code(fromURL: callbackURL)
        }
    }

    public func authToken(forCode code: String) async throws -> Bearer {
        try await api.auth.token(forCode: code)
    }

    public var isAuthorized: Bool {
        api.isAuthorized
    }

    public func me() async throws -> User {
        try await api.users.me()
    }

    public func users(_ query: String) async throws -> [BasicUser] {
        try await api.users.search(query)
    }
}
