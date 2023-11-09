//
//  HomeViewController.swift
//  cricArena
//
//  Created by bjit on 13/2/23.
//

import UIKit
import Combine
import UserNotifications

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var upcomingMatchView: UICollectionView!
    @IBOutlet weak var recentMatchesTable: UITableView!
    @IBOutlet weak var recentMatchesTag: UILabel!
    @IBOutlet weak var checkInternet: UIView!
    var homeViewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    // notification
    let notificationCenter = UNUserNotificationCenter.current()
    let dateString = "2023-02-23T07:30:00.000000Z"
    let dateFormatter = DateFormatter()
    let matchTimeLabel = UILabel()
    var notificationTriggered = false
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingMatchView.layer.cornerRadius = 20
        upcomingMatchView.dataSource = self
        upcomingMatchView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 350, height: 220)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        upcomingMatchView.collectionViewLayout = layout
        recentMatchesTable.dataSource = self
        recentMatchesTable.delegate = self
        // homeViewModel.fetchLiveMatch()
        homeViewModel.fetchUpcomingMatch()
        homeViewModel.fetchRecentMatch()
        binder()
        checkInternet.isHidden = true
    }
    
    @IBAction func notifyButtonTapped(_ sender: Any) {
        
    }
    func binder() {
        homeViewModel.$liveMatchList.sink { [weak self] _ in
            DispatchQueue.main.async {
                print("test livematch list binder")
                self?.upcomingMatchView.reloadData()
            }
        }.store(in: &cancellables)
        
        homeViewModel.$recentMatchList.sink { [weak self] _ in
            DispatchQueue.main.async {
                print("test recentmatch list binder")
                self?.recentMatchesTable.reloadData()
            }
        }.store(in: &cancellables)
        homeViewModel.$upcomingMatchList.sink { [weak self] _ in
            DispatchQueue.main.async {
                print("test upcomingmatch list binder")
                self?.upcomingMatchView.reloadData()
            }
        }.store(in: &cancellables)
        
        homeViewModel.$checkInternet.sink { [weak self] checkStatus in
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
extension HomeViewController: UICollectionViewDataSource{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.upcomingMatchView.isHidden = true
                self?.collectionViewHeight.constant = 210
                self?.collectionViewHeight.constant = 0
                self?.recentMatchesTag.textColor = UIColor(hex: 0xFFFFFF)
                self?.recentMatchesTag.font = UIFont(name: "Helvetica-Bold", size: 25)
                self?.view.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.upcomingMatchView.isHidden = false
                self?.collectionViewHeight.constant = 0
                self?.collectionViewHeight.constant = 210
                self?.recentMatchesTag.textColor = UIColor(hex: 0x000000)
                self?.view.layoutIfNeeded()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.upcomingMatchList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let upcomingMatchesCell = upcomingMatchView.dequeueReusableCell(withReuseIdentifier: "upcomingMatchesCell", for: indexPath) as? UpcomingMatchesCollectionViewCell
        guard let upcomingMatchesCell = upcomingMatchesCell else { return UICollectionViewCell()}
        guard let upcomingMatchesList = homeViewModel.upcomingMatchList else { return UICollectionViewCell() }
        upcomingMatchesCell.setMatch(matchInfo: upcomingMatchesList[indexPath.row])
        return upcomingMatchesCell
    }
    // animation
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), options: .curveEaseInOut, animations: {
            cell.alpha = 1
        }, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let upcomingMatchesCell = homeViewModel.upcomingMatchList else { return }
        homeViewModel.getMatchDetails(matchId: upcomingMatchesCell[indexPath.row].id ?? 10 , originViewController: self)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.recentMatchList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recentMatchesCell = recentMatchesTable.dequeueReusableCell(withIdentifier: "recentMatcesCell", for: indexPath) as? RecentMatchesTableViewCell
        guard let recentMatchesCell = recentMatchesCell else { return UITableViewCell()}
        guard let recentMatchesList = homeViewModel.recentMatchList else { return UITableViewCell() }
        recentMatchesCell.setMatch(matchInfo: recentMatchesList[indexPath.row])
        return recentMatchesCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recentMatchesCell = homeViewModel.recentMatchList else { return}
        homeViewModel.getMatchDetails(matchId: recentMatchesCell[indexPath.row].id ?? 10 , originViewController: self)
    }
}


