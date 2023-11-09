//
//  SearchPlayerViewModel.swift
//  cricArena
//
//  Created by bjit on 20/2/23.
//
import Foundation
import UIKit
import CoreData
class SearchPlayerViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @Published var allPlayerList: [AllPlayer]?
    func fetchAllPlayerData() {
        guard let url = apiConfig.getAllPlayerDetailsUrl else {
            return
        }
        print(url)
        APIService.fetchData(from: url) { (result: Result<Player, Error>) in
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
                DispatchQueue.main.async {
                    addData(data: playerList)
                }
                self.allPlayerList = playerList.data
            }
        }
    }
    func getPlayerDetails(playerId: Int, originViewController:SearchPlayerViewController ){
        let playerDetailsViewController = UIStoryboard(name: "SearchPlayer",bundle: nil).instantiateViewController(withIdentifier: "searchedPlayerDetailsViewController") as? SearchedPlayerDetailsViewController
        guard let playerDetailsViewController = playerDetailsViewController else { return }
        playerDetailsViewController.trappedPlayerId = playerId
        originViewController.navigationController?.pushViewController(playerDetailsViewController, animated: true)
    }
}

func addData(data: Player) {
    let dataArr = data.data
    var dataArray = [[String: Any]]()
    guard let dataArr = dataArr else {
        return
    }
    for val in dataArr {
        if let playerId = val.id,
           let playerName = val.fullname,
           let playerImage = val.image_path {
            let dict: [String: Any] = ["playerId": Int32(playerId)
                                       , "playerName": playerName,
                                       "playerImage": playerImage]
            dataArray.append(dict)
        }
    }
    
    let insert = NSBatchInsertRequest(entity: PlayerInfo.entity(), objects: dataArray)
    do{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try context.execute(insert)
    }catch{
        print(error)
    }
}
