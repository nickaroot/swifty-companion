//
//  CursusUser.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

public struct CursusUser: Codable {
    public var id: Int
    public var grade: String?
    public var level: Double?
    public var skills: [UserSkill]?
    public var blackholedAt: Date?
    public var loginAt: Date?
    public var endAt: Date?
    public var cursusID: Int
    public var hasCoalition: Bool?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var cursus: BasicCursus?

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case grade = "grade"
        case level = "level"
        case skills = "skills"
        case blackholedAt = "blackholed_at"
        case loginAt = "login_at"
        case endAt = "end_at"
        case cursusID = "cursus_id"
        case hasCoalition = "has_coalition"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cursus = "cursus"
    }
}
