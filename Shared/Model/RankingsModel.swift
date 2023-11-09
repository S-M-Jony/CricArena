//
//  RankingsModel.swift
//  cricArena
//
//  Created by bjit on 21/2/23.
//

import Foundation
// MARK: - Welcome
struct TeamRanking: Codable {
    let data: [TopTeamRanking]?
}
// MARK: - Datum
struct TopTeamRanking: Codable {
    let resource, type: String?
    let gender, updatedAt: String?
    let team: [TeamInfo]?
}

// MARK: - Team
struct TeamInfo: Codable {
    let id: Int?
    let name, code: String?
    let image_path: String?
    let countryID: Int?
    let nationalTeam: Bool?
    let position: Int?
    let updatedAt: String?
    let ranking: Ranking?
}

// MARK: - Ranking
struct Ranking: Codable {
    let position, matches, points, rating: Int?
}
