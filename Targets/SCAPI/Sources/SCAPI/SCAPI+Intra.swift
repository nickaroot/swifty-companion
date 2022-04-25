//
//  SCAPI+Intra.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 23.04.2022.
//

import Alamofire
import Foundation
import SCHelpers

public class Intra {

    public class Profile {

        // MARK: - Base URL

        public class var baseURL: URL? {
            URL(string: "https://profile.intra.42.fr")
        }

        // MARK: - User

        public class var userURL: ((String) -> URL?) {
            { login in
                URL(
                    string: "/users/\(login)",
                    relativeTo: baseURL
                )
            }
        }

        // MARK: - Experiences

        public class var experiencesURL: ((String, Int) -> URL?) {
            { login, cursusID in
                URL(
                    string: "/users/\(login)/experiences/cursus_id/\(cursusID)",
                    relativeTo: baseURL
                )
            }
        }
    }
}
