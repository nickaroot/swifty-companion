//
//  Skill.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

public struct UserSkill: Codable {
    public var id: Int
    public var name: String
    public var level: Double

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case level = "level"
    }
}
