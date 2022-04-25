//
//  SCAPI+Users.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Alamofire
import Foundation
import SCHelpers

protocol SCAPIUsersOutput: AnyObject {
    var baseURL: URL? { get }

    var session: Session { get }
}

extension SCAPI {
    // MARK: - Users

    public class Users {
        weak var api: SCAPIUsersOutput!

        // MARK: - Search

        public var usersURL: URL? {
            URL(
                string: "/v2/users",
                relativeTo: api.baseURL
            )
        }

        struct SearchParameters: Encodable {
            enum SortField: String, Encodable {
                case id = "id"
                case login = "login"
                case email = "email"
                case createdAt = "created_at"
                case updatedAt = "updated_at"
                case image = "image"
                case firstName = "first_name"
                case lastName = "last_name"
                case poolYear = "pool_year"
                case poolMonth = "pool_month"
                case kind = "kind"
                case status = "status"
                case usualFirstName = "usual_first_name"
                case alumni = "alumni"

                case idDesc = "-id"
                case loginDesc = "-login"
                case emailDesc = "-email"
                case createdAtDesc = "-created_at"
                case updatedAtDesc = "-updated_at"
                case imageDesc = "-image"
                case firstNameDesc = "-first_name"
                case lastNameDesc = "-last_name"
                case poolYearDesc = "-pool_year"
                case poolMonthDesc = "-pool_month"
                case kindDesc = "-kind"
                case statusDesc = "-status"
                case usualFirstNameDesc = "-usual_first_name"
                case alumniDesc = "-alumni"
            }

            var range: [String: String]
            var sort: SortField
        }

        var searchQueue = DispatchQueue(
            label: "scsearch",
            qos: .userInitiated,
            attributes: [.concurrent, .initiallyInactive],
            autoreleaseFrequency: .never,
            target: .global(qos: .userInitiated)
        )

        public func search(_ query: String) async throws -> [BasicUser] {
            guard let usersURL = usersURL else { throw .api.invalidURL }

            let parameters = SearchParameters(
                range: [
                    "login": "\(query),z"
                ],
                sort: .login
            )

            let request = api.session.request(usersURL, method: .get, parameters: parameters)

            api.session.session.getAllTasks { tasks in
                for task in tasks {
                    guard
                        let newRequest = request.convertible.urlRequest,
                        let oldRequest = task.currentRequest?.urlRequest,
                        oldRequest.url == newRequest.url,
                        oldRequest.method == newRequest.method
                    else {
                        continue
                    }

                    task.cancel()
                }
            }

            return try await request.serializingIntra().value
        }

        // MARK: - Me

        public var meURL: URL? {
            URL(
                string: "/v2/me",
                relativeTo: api.baseURL
            )
        }

        public func me() async throws -> User {
            guard let meURL = meURL else { throw .api.invalidURL }

            let request = api.session.request(meURL, method: .get)

            return try await request.serializingIntra().value
        }

        // MARK: - User

        public var userURL: ((Int) -> URL?) {
            { [unowned self] (userID) in
                URL(
                    string: "/v2/users/\(userID)",
                    relativeTo: api.baseURL
                )
            }
        }

        public func user(id userID: Int) async throws -> User {
            guard let userURL = userURL(userID) else { throw .api.invalidURL }

            let request = api.session.request(userURL, method: .get)

            return try await request.serializingIntra().value
        }
    }
}
