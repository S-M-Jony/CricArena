//
//  SearchPlayerViewController.swift
//  cricArena
//
//  Created by bjit on 20/2/23.
//

import UIKit
import Combine
import CoreData
class SearchPlayerViewController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchBarButton: UIButton!
    @IBOutlet weak var searchPlayerTable: UITableView!
    var searchPlayerViewModel = SearchPlayerViewModel()
    private var cancellables: Set<AnyCancellable> = []
    var items: [PlayerInfo] = []
    var playerLabel : [PlayerInfo]? = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.clearButtonMode = .whileEditing
        searchBar.delegate = self
        searchPlayerTable.dataSource = self
        searchPlayerTable.delegate = self
        //searchPlayerViewModel.fetchAllPlayerData()
        fetchPlayer()
        binder()
        playerLabel = playerSearch(search: " ")
        print(playerLabel?.count ?? 0)
        searchPlayerTable.reloadData()
    }
    func binder() {
        searchPlayerViewModel.$allPlayerList.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.searchPlayerTable.reloadData()
            }
        }.store(in: &cancellables)
    }
    func fetchPlayer(){
        playerLabel = playerSearch(search: " ")
        print(playerLabel?.count ?? 0)
        if playerLabel?.count == 0 {
            searchPlayerViewModel.fetchAllPlayerData()
        }
    }
    func playerSearch(search: String)-> [PlayerInfo]? {
        do{
            let fetchRequest = NSFetchRequest<PlayerInfo>(entityName: "PlayerInfo")
            let predicate = NSPredicate(format: "playerName CONTAINS [cd] %@", search)
            fetchRequest.predicate = predicate
            let fetchModel = try context.fetch(fetchRequest)
            items = fetchModel
            return fetchModel
        } catch{
            print(error)
            return nil
        }
    }
}
extension SearchPlayerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (searchBar.text! as NSString).replacingCharacters(in: range, with: string)
        if text != ""{
            self.playerLabel = playerSearch(search: text)
            searchPlayerTable.reloadData()
        }
        return true
    }
}

extension SearchPlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchPlayerCell = searchPlayerTable.dequeueReusableCell(withIdentifier: "SearchPlayerTableViewCell", for: indexPath) as? SearchPlayerTableViewCell
        guard let searchPlayerCell = searchPlayerCell else { return UITableViewCell()}
        searchPlayerCell.setPlayer(playerInfo: items[indexPath.row])
        return searchPlayerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SearchPlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchPlayerViewModel.getPlayerDetails(playerId: Int(items[indexPath.row].playerId), originViewController: self)
        print(items[indexPath.row].playerId)
    }
}





