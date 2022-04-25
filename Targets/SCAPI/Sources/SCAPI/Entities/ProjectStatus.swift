//
//  ProjectStatus.swift
//  SCAPI
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Foundation

public enum ProjectStatus: String, Codable {
    case waitingToStart = "waiting_to_start"
    case searchingAGroup = "searching_a_group"
    case creatingGroup = "creating_group"
    case inProgress = "in_progress"
    case waitingForCorrection = "waiting_for_correction"
    case finished = "finished"
    case parent = "parent"
}
