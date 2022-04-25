//
//  SCAPI+Cursus.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Alamofire
import Foundation
import SCHelpers

protocol SCAPICursusOutput: AnyObject {
    var baseURL: URL? { get }

    var session: Session { get }
}

extension SCAPI {
    // MARK: - Users

    public class Cursus {
        weak var api: SCAPICursusOutput!

        // MARK: - Skills

        public var skillsURL: ((Int) -> URL?) {
            { [unowned self] cursusID in
                URL(
                    string: "/v2/cursus/\(cursusID)/skills",
                    relativeTo: api.baseURL
                )
            }
        }

        public func skills(forCursus cursusID: Int) async throws -> [Skill] {
            guard let skillsURL = skillsURL(cursusID) else { throw .api.invalidURL }

            let request = api.session.request(skillsURL, method: .get)

            return try await request.serializingIntra().value
        }
    }
}
