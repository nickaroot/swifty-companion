//
//  SCProfileInteractorInput.swift
//
//  Created by Nikita Arutyunov on 11.04.2022.
//

import SCAPI
import SCUI

public protocol SCProfileInteractorInput: SCInteractorInputProtocol {
    func getUser(id userID: Int) async throws -> User

    func skills(forCursus cursusID: Int) async throws -> [Skill]
}

extension SCProfileInteractor: SCProfileInteractorInput {
    public func getUser(id userID: Int) async throws -> User {
        try await api.users.user(id: userID)
    }

    public func skills(forCursus cursusID: Int) async throws -> [Skill] {
        try await api.cursus.skills(forCursus: cursusID)
    }
}
