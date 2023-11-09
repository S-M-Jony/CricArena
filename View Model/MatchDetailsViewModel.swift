//
//  MatchDetailsViewModel.swift
//  cricArena
//
//  Created by bjit on 17/2/23.
//

import Foundation

class MatchDetailsViewModel {
    @Published var matchDetails: MatchData?
    @Published var matchInfo: MatchData?
    func fetchMatchDetails(matchId: Int){
        guard let url = apiConfig.getMatchDetailsUrl(matchId: matchId) else {
            return
        }
        print(url)
        APIService.fetchData(from: url) { (result: Result<MatchDetails,Error>) in
            switch result {
            case .failure(let error):
                if let error = error as? URLError,
                   error.code == .notConnectedToInternet {
                    print("No Internet")
                }
                else {
                    print(error.localizedDescription)
                }
            case .success(let match):
                print("Match details Result", match)
                self.matchDetails = match.data
                self.matchInfo = match.data
            }
        }
    }
}
