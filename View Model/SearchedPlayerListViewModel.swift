//
//  SearchPlayerListViewModel.swift
//  cricArena
//
//  Created by bjit on 22/2/23.
//

import Foundation
class SearchedPlayerListViewModel {
    @Published var playerDetails: DataClassPlayerDetail?
    func getPlayerDetails(playerId: Int){
        guard let url = apiConfig.getPlayerDetails(playerID: playerId) else {
            return
        }
        print(url)
        APIService.fetchData(from: url) { (result: Result<PlayerDetail, Error>) in
            switch result {
            case .failure(let error):
                if let error = error as? URLError,
                   error.code == .notConnectedToInternet {
                    print("No Internet")
                }
                else {
                    print(error.localizedDescription)
                }
            case .success(let playerList):
                self.playerDetails = playerList.data
            }
        }
    }
}
