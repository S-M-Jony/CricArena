//
//  RankingsViewController.swift
//  cricArena
//
//  Created by bjit on 21/2/23.
//

import UIKit
import Combine
class RankingsViewController: UIViewController {
    @IBOutlet weak var rankingHeader: UIView!
    @IBOutlet weak var rangkingSegment: UISegmentedControl!
    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var rankingSegmentView: UIView!
    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet weak var checkInternet: UIView!
    var rankingsViewModel = RankingsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingSegmentView.cornerRadius()
        rankingSegmentView.shadow()
        rankingsViewModel.fetchRankingsData()
        rankingTableView.dataSource = self
        rankingTableView.delegate = self
        binder()
        checkInternet.isHidden = true
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        rangkingSegment.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        rangkingSegment.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
    }
    
    @IBAction func rankingSegment(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            rankingsViewModel.getRankingData(category: "test", passData: rankingsViewModel.teamRank)
            rankingTableView.reloadData()
        case 1:
            rankingsViewModel.getRankingData(category: "odi", passData: rankingsViewModel.teamRank)
            rankingTableView.reloadData()
        case 2:
            rankingsViewModel.getRankingData(category: "t20", passData: rankingsViewModel.teamRank)
            rankingTableView.reloadData()
        default:
            break
        }
    }
    func binder() {
        rankingsViewModel.$teamRank.sink { [weak self] data in
            DispatchQueue.main.async {
                print("Ranking binder")
                // self?.rankingTableView.reloadData()
                self?.rankingsViewModel.getRankingData(category: "test", passData: data)
                self?.rankingTableView.reloadData()
                
            }
        }.store(in: &cancellables)
        rankingsViewModel.$checkInternet.sink { [weak self] checkStatus in
            DispatchQueue.main.async {
                if checkStatus == true{
                    self?.checkInternet.isHidden = false
                }
                else {
                    self?.checkInternet.isHidden = true
                }
            }
        }.store(in: &cancellables)
    }
}
extension RankingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankingsViewModel.team?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rankingCell = rankingTableView.dequeueReusableCell(withIdentifier: "RankingsTableViewCell", for: indexPath) as? RankingsTableViewCell
        guard let rankingCell = rankingCell else { return UITableViewCell() }
        guard let rankingList = rankingsViewModel.team else { return UITableViewCell() }
        rankingCell.setRank(teamInfo: rankingList[indexPath.row])
        return rankingCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rankingTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
}
extension RankingsViewController: UITableViewDelegate {
}

