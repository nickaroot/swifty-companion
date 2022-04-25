//
//  BasicProject.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

public struct BasicProject: Codable {
    public var id: Int
    public var name: String
    public var slug: String
    public var parentID: Int?

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case slug = "slug"
        case parentID = "parent_id"
    }
}
