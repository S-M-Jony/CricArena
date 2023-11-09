//
//  FixturesModel.swift
//  cricArena
//
//  Created by bjit on 14/2/23.
//

import Foundation
class FixtureViewModel {
    @Published var checkInternet: Bool?
    @Published var matchList: [Match]?
    func fetchFixture(leagueId: Int){
        guard let url = apiConfig.getFixtures(leagueId: leagueId) else {
            return
        }
        print(url)
        APIService.fetchData(from: url) { (result: Result<MatchList,Error>) in
            switch result {
            case .failure(let error):
                if let error = error as? URLError,
                   error.code == .notConnectedToInternet {
                    print("No Internet from fixtures tab")
                    self.checkInternet = true
                }
                else {
                    print(error.localizedDescription)
                }
            case .success(let fixtures):
                print("Match details Result", fixtures)
                self.checkInternet = false
                self.matchList = fixtures.data
            }
        }
    }
}
