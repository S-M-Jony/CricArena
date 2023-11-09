//
//  SearchPlayerDetailsModel.swift
//  cricArena
//
//  Created by bjit on 22/2/23.
//

import Foundation
// MARK: - Welcome
struct PlayerDetail: Codable {
    let data: DataClassPlayerDetail?
}
// MARK: - DataClass
struct DataClassPlayerDetail: Codable {
    let resource: String?
    let id, countryID: Int?
    let firstname, lastname, fullname: String?
    let image_path: String?
    let dateofbirth, gender, battingstyle, bowlingstyle: String?
    let position: PositionPlayerDetail?
    let country: Country?
    let updatedAt: String?
    let career: [Career]?
    let teams: [TeamPlayerDetail]?
}
// MARK: - Career
struct Career: Codable {
    let resource, type: String?
    let seasonID, playerID: Int?
    let batting: [String: Double]?
    let bowling: [String: Double]?
    let updatedAt: String?
}

// MARK: - Country
struct Country: Codable {
    let resource: String?
    let id, continentID: Int?
    let name: String?
    let image_path: String?
    let updatedAt: String?
}

// MARK: - Position
struct PositionPlayerDetail: Codable {
    let resource: String?
    let id: Int?
    let name: String?
}

// MARK: - Team
struct TeamPlayerDetail: Codable {
    let resource: String?
    let id: Int?
    let name, code: String?
    let imagePath: String?
    let countryID: Int?
    let nationalTeam: Bool?
    let updatedAt: String?
    let inSquad: InSquad?
}

// MARK: - InSquad
struct InSquad: Codable {
    let seasonID, leagueID: Int?
}
