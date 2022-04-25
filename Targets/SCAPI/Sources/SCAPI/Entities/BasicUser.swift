//
//  User.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

public struct BasicUser: Codable {
    public var id: Int
    public var email: String?
    public var login: String?
    public var firstName: String?
    public var lastName: String?
    public var usualFullName: String?
    public var usualFirstName: String?
    public var url: String?
    public var phone: String?
    public var displayName: String?
    public var imageURL: String?
    public var newImageURL: String?
    public var isStaff: Bool?
    public var correctionPoint: Int?
    public var poolMonth: String?
    public var poolYear: String?
    public var location: String?
    public var wallet: Int?
    public var anonymizeDate: Date?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var isAlumni: Bool?
    public var isLaunched: Bool?

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case login = "login"
        case firstName = "first_name"
        case lastName = "last_mame"
        case usualFullName = "usual_full_name"
        case usualFirstName = "usual_first_name"
        case phone = "phone"
        case displayName = "displayname"
        case imageURL = "image_url"
        case newImageURL = "new_image_url"
        case isStaff = "staff?"
        case correctionPoint = "correction_point"
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case location = "location"
        case wallet = "wallet"
        case anonymizeDate = "anonymize_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isAlumni = "alumni"
        case isLaunched = "is_launched?"
    }
}
