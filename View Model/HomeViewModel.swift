//
//  HomeViewModel.swift
//  cricArena
//
//  Created by bjit on 13/2/23.
//

import Foundation
import UIKit
class HomeViewModel {
    @Published var liveMatchList: [Match]?
    @Published var recentMatchList: [Match]?
    @Published var upcomingMatchList: [Match]?
    @Published var checkInternet: Bool?
    func fetchLiveMatch() {
        guard let url = apiConfig.getUpcomingMatchUrl else {
            return
        }
        print(url)
        APIService.fetchData(from: url) { (result: Result<MatchList, Error>) in
            switch result {
            case .failure(let error):
                if let error = error as? URLError,
                   error.code == .notConnectedToInternet {
                    print("No Internet from view")
                    self.checkInternet = true
                }
                else {
                    print(error.localizedDescription)
                }
            case .success(let liveMatch):
               // print("Match Result", liveMatch)
                self.checkInternet = false
                self.liveMatchList = liveMatch.data
            }
        }
    }
    
    func fetchRecentMatch() {
        guard let url = apiConfig.getRecentMatchUrl else {
            return
        }
       // print(url)
        APIService.fetchData(from: url) { (result: Result<MatchList, Error>) in
            switch result {
            case .failure(let error):
                if let error = error as? URLError,
                   error.code == .notConnectedToInternet {
                    print("No Internet from recent ")
                    self.checkInternet = true
                }
                else {
                    print(error.localizedDescription)
                }
            case .success(let recentMatch):
                //print("Match Result", recentMatch)
                self.checkInternet = false
                self.recentMatchList = recentMatch.data
            }
        }
    }
    
    func fetchUpcomingMatch() {
        guard let url = apiConfig.getUpcomingMatchUrl else {
            return
        }
        //print(url)
        APIService.fetchData(from: url) { (result: Result<MatchList, Error>) in
            switch result {
            case .failure(let error):
                if let error = error as? URLError,
                   error.code == .notConnectedToInternet {
                    self.checkInternet = true
                    print("No Internet")
                }
                else {
                    print(error.localizedDescription)
                }
            case .success(let upcomingMatch):
                //print("Match Result", upcomingMatch)
                self.checkInternet = false
                self.upcomingMatchList = upcomingMatch.data
            }
        }
    }
    func getMatchDetails(matchId: Int, originViewController:HomeViewController ){
        let matchDetailsViewController = UIStoryboard(name: "Home",bundle: nil).instantiateViewController(withIdentifier: "matchDetailsViewController") as? MatchDetailsViewController
        guard let matchDetailsViewController = matchDetailsViewController else { return }
        matchDetailsViewController.trappedMatchId = matchId
        originViewController.navigationController?.pushViewController(matchDetailsViewController, animated: true)
    }
}
