//
//  ProjectsUser.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

public struct ProjectsUser: Codable {
    public var id: Int
    public var occurence: Int?
    public var finalMark: Int?
    public var status: ProjectStatus?
    public var isValidated: Bool?
    public var currentTeamID: Int?
    public var project: BasicProject?
    public var cursusIDs: [Int]
    public var markedAt: Date?
    public var isMarked: Bool?
    public var retriableAt: Date?
    public var createdAt: Date?
    public var updatedAt: Date?

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case occurence = "occurence"
        case finalMark = "final_mark"
        case status = "status"
        case isValidated = "validated?"
        case currentTeamID = "current_team_id"
        case project = "project"
        case cursusIDs = "cursus_ids"
        case markedAt = "marked_at"
        case isMarked = "marked"
        case retriableAt = "retriable_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
