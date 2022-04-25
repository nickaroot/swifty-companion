//
//  Bearer.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 18.04.2022.
//

import Alamofire
import Foundation

public struct Bearer: Codable, AuthenticationCredential {
    public var requiresRefresh: Bool {
        let expirationTimeInterval = TimeInterval(createdAt) + TimeInterval(expiresIn) + 60
        let expirationDate = Date(timeIntervalSince1970: expirationTimeInterval)
        let nowDate = Date()

        return nowDate >= expirationDate
    }

    public let accessToken: String
    public let refreshToken: String
    public let createdAt: Int
    public let expiresIn: Int
    public let tokenType: String
    public let scope: String

    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope = "scope"
    }

    public init(
        accessToken: String,
        refreshToken: String,
        createdAt: Int,
        expiresIn: Int,
        tokenType: String,
        scope: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.createdAt = createdAt
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.scope = scope
    }
}
