//
//  Skill.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

public struct Skill: Codable {
    public var id: Int
    public var slug: String?
    public var name: String
    public var createdAt: Date?

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case slug = "slug"
        case name = "name"
        case createdAt = "created_at"
    }
}
