//
//  SCAPI+Error.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 23.04.2022.
//

import Foundation

extension SCAPI {
    public enum APIError: Error, Equatable {
        case invalidURL, invalidRequest, invalidResponse

        public enum Auth: Equatable {
            case invalidSecrets, invalidCode, invalidRefresh
        }

        case auth(Auth)

        public enum Keychain: Equatable {
            case unableToAdd, unableToUpdate
        }

        case keychain(Keychain)

        case custom(errorDescription: String)
    }
}

extension SCAPI.APIError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"

        case .invalidRequest:
            return "Invalid request"

        case .invalidResponse:
            return "Invalid response"

        case .auth(let auth):
            switch auth {
            case .invalidSecrets:
                return "Invalid secrets"

            case .invalidCode:
                return "Invalid code"

            case .invalidRefresh:
                return "Invalid refresh"
            }

        case .keychain(let keychain):
            switch keychain {
            case .unableToAdd:
                return "Unable to add Token to Keychain"

            case .unableToUpdate:
                return "Unable to update Token on Keychain"
            }

        case .custom(let errorDescription):
            return errorDescription
        }
    }
}

extension SCAPI.APIError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"

        case .invalidRequest:
            return "Invalid request"

        case .invalidResponse:
            return "Invalid response"

        case .auth(let auth):
            switch auth {
            case .invalidSecrets:
                return "Invalid secrets"

            case .invalidCode:
                return "Invalid code"

            case .invalidRefresh:
                return "Invalid refresh"
            }

        case .keychain(let keychain):
            switch keychain {
            case .unableToAdd:
                return "Unable to add Token to Keychain"

            case .unableToUpdate:
                return "Unable to update Token on Keychain"
            }

        case .custom(let errorDescription):
            return errorDescription
        }
    }
}

extension Error {
    public typealias api = SCAPI.APIError
}
