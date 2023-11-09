//
//  ScoreCardViewModel.swift
//  cricArena
//
//  Created by bjit on 17/2/23.
//

import Foundation
class ScoreCardViewModel {
    @Published var teamBattingDetails: [Batting]?
    @Published var teamBowlingDetails: [Bowling]?
    func prepareTeamWiseScoreData(teamId: Int){
        guard let matchData = MatchDetailsViewController.matchDetailsViewModel.matchDetails else {return}
        var teamBatting: [Batting] = []
        var teamBowling: [Bowling] = []
        
        if !matchData.batting.isEmpty {
            for i in 0...(matchData.batting.count - 1) {
                if teamId == matchData.batting[i].team_id {
                    teamBatting.append(matchData.batting[i])
                }
            }
            for i in 0...(matchData.bowling.count - 1) {
                if teamId == matchData.bowling[i].team_id {
                    teamBowling.append(matchData.bowling[i])
                }
            }
        }
        teamBattingDetails = teamBatting
        teamBowlingDetails = teamBowling
    }
}

