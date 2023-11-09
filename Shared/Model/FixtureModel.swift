//
//  FixtureModel.swift
//  cricArena
//
//  Created by bjit on 14/2/23.
//

import Foundation
struct MatchList: Codable {
    let data: [Match]?
}
struct Match: Codable {
    let id: Int?
    let starting_at: String
    let type: String
    let round: String
    let note: String
    let localteam: Team?
    let visitorteam: Team?
    let runs: [Run]
    let status: String?
}
struct Team: Codable {
    let id: Int?
    let code: String?
    let image_path: String?
}
struct Run: Codable {
    let id, fixture_id, team_id , inning: Int?
    let score, wickets: Int?
    let overs: Double?
}
