//
//  FixturesViewController.swift
//  cricArena
//
//  Created by bjit on 14/2/23.
//

import UIKit
import Combine
class FixturesViewController: UIViewController {
    let fixtureViewModel = FixtureViewModel()
    @IBOutlet weak var fixtureSegmentController: UISegmentedControl!
    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet weak var fixtureTable: UITableView!
    @IBOutlet weak var leagueView: UIView!
    @IBOutlet weak var checkInternet: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        leagueView.shadow()
        fixtureTable.dataSource = self
        fixtureTable.delegate = self
        fixtureViewModel.fetchFixture(leagueId: 3)
        binder()
        checkInternet.isHidden = true
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        fixtureSegmentController.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        fixtureSegmentController.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
    }
    @IBAction func fixtureSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            fixtureViewModel.fetchFixture(leagueId: 3)
            fixtureTable.reloadData()
        case 1:
            fixtureViewModel.fetchFixture(leagueId: 5)
            fixtureTable.reloadData()
        case 2:
            fixtureViewModel.fetchFixture(leagueId: 10)
            fixtureTable.reloadData()
        default:
            break
        }
    }
    
    func binder() {
        fixtureViewModel.$checkInternet.sink { [weak self] checkStatus in
            DispatchQueue.main.async {
                if checkStatus == true{
                    self?.checkInternet.isHidden = false
                }
                else {
                    self?.checkInternet.isHidden = true
                }
            }
        }.store(in: &cancellables)
        
        fixtureViewModel.$matchList.sink { [weak self] _ in
            DispatchQueue.main.async {
                print("fixture list binder")
                self?.fixtureTable.reloadData()
            }
        }.store(in: &cancellables)
    }
}

extension FixturesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fixtureViewModel.matchList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fixtureMatchesCell = fixtureTable.dequeueReusableCell(withIdentifier: "FixtureTablwViewCell", for: indexPath) as? FixtureTableViewCell
        guard let fixtureMatchesCell = fixtureMatchesCell else { return UITableViewCell() }
        guard let fixtureMatchesList = fixtureViewModel.matchList else { return UITableViewCell() }
        fixtureMatchesCell.setMatch(matchInfo: fixtureMatchesList[indexPath.row])
        return fixtureMatchesCell
    }
    
}
extension FixturesViewController: UITableViewDelegate{
    
}
    



