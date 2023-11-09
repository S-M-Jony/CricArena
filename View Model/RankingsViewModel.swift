//
//  RankingsViewModel.swift
//  cricArena
//
//  Created by bjit on 21/2/23.
//

import Foundation
class RankingsViewModel {
    @Published var teamRank: [TopTeamRanking]?
    @Published var team: [TeamInfo]?
    @Published var checkInternet: Bool?
    func fetchRankingsData() {
        guard let url = apiConfig.getRankingsUrl else {
            return
        }
        print(url)
        APIService.fetchData(from: url) { (result: Result<TeamRanking, Error>) in
            print(result)
            switch result {
            case .failure(let error):
                if let error = error as? URLError,
                   error.code == .notConnectedToInternet {
                    self.checkInternet = true
                    print("No Internet from raking")
                }
                else {
                    print(error.localizedDescription)
                }
            case .success(let rank):
                print("All player data", rank)
                self.checkInternet = false
                self.teamRank = rank.data
            }
        }
    }
    func getRankingData(category: String, passData: [TopTeamRanking]?){
        if category == "test" {
            team = passData?[0].team.map{$0}
        }
        
        if category == "odi" {
            team = passData?[1].team.map{$0}
        }
        
        if category == "t20" {
            team = passData?[2].team.map{$0}
        }
    }
}
