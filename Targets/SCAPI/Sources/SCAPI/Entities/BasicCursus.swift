//
//  BasicCursus.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

public struct BasicCursus: Codable {
    public var id: Int
    public var createdAt: Date?
    public var name: String
    public var slug: String

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case name = "name"
        case slug = "slug"
    }
}
