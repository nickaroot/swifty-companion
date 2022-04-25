//
//  SCProfilePresenter+ProjectsDelegate.swift
//  SCProfile
//
//  Created by Nikita Arutyunov on 12.04.2022.
//

import SCAPI
import UIKit

protocol ProjectsDelegate: AnyObject {
    func project(modelAtIndex index: Int) -> ProjectsUser?

    func projectsCount() -> Int

    func didSelectProject(modelAtIndex index: Int)
}

extension SCProfilePresenter: ProjectsDelegate {
    func project(modelAtIndex index: Int) -> ProjectsUser? {
        guard
            let projects = projects,
            index >= 0, index < projects.count
        else { return nil }

        return projects[index]
    }

    func projectsCount() -> Int {
        guard let projects = projects else { return 0 }

        return projects.count
    }

    func didSelectProject(modelAtIndex index: Int) {
        guard let projectUser = project(modelAtIndex: index) else { return }

        guard let slug = projectUser.project?.slug,
            let projectUserURL = URL(
                string:
                    "https://projects.intra.42.fr/projects/\(slug)/projects_users/\(projectUser.id)"
            )
        else {
            return
        }

        if UIApplication.shared.canOpenURL(projectUserURL) {
            UIApplication.shared.open(projectUserURL)
        }
    }
}
