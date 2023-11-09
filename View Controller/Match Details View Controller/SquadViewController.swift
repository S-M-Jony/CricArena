//
//  SquadViewController.swift
//  cricArena
//
//  Created by bjit on 17/2/23.
//

import UIKit
import Combine
class SquadViewController: UIViewController {
    @IBOutlet weak var squadSegment: UISegmentedControl!
    @IBOutlet weak var squadTableView: UITableView!
    @IBOutlet weak var squadHeaderView: UIView!
    private var cancellables: Set<AnyCancellable> = []
    let squadViewModel = SquadViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        squadTableView.dataSource = self
        squadTableView.delegate = self
        squadHeaderView.shadow()
        configureSquadCell()
        binder()
    }
    func configureSquadCell(){
        let playerNib = UINib(nibName: "SquadTableViewCell", bundle: nil)
        squadTableView.register(playerNib, forCellReuseIdentifier: "SquadTableViewCell")
    }
    func binder() {
        MatchDetailsViewController.matchDetailsViewModel.$matchInfo.sink { [weak self] matchData in
            guard let self = self else {return}
            guard let matchData = matchData else {return}
            dump(matchData)
            DispatchQueue.main.async {
                self.configureSquadSegment()
            }
            self.squadViewModel.prepareTeamWiseLineup(teamId: matchData.localteam?.id ?? 0)
        }.store(in: &cancellables)
        squadViewModel.$teamLineup.sink { [weak self] data in
            guard let self = self else {return}
            dump(data)
            DispatchQueue.main.async {
                self.squadTableView.reloadSections([0], with: .automatic)
            }
        }.store(in: &cancellables)
    }
    func configureSquadSegment(){
        squadSegment.setTitle(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.localteam?.name, forSegmentAt: 0)
        squadSegment.setTitle(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.visitorteam?.name, forSegmentAt: 1)
    }
    
    @IBAction func teamSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            squadViewModel.prepareTeamWiseLineup(teamId: MatchDetailsViewController.matchDetailsViewModel.matchDetails?.localteam?.id ?? 0)
        case 1:
            squadViewModel.prepareTeamWiseLineup(teamId: MatchDetailsViewController.matchDetailsViewModel.matchDetails?.visitorteam?.id ?? 0)
        default:
            break
        }
    }
}


extension SquadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return squadViewModel.teamLineup?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playerCell = squadTableView.dequeueReusableCell(withIdentifier: "SquadTableViewCell", for: indexPath) as? SquadTableViewCell
        guard let playerCell = playerCell else {return UITableViewCell()}
        guard let teamLineup = squadViewModel.teamLineup else {return UITableViewCell()}
        if MatchDetailsViewController.matchDetailsViewModel.matchDetails?.status == "Finished" {
            playerCell.playerName.text = teamLineup[indexPath.row].fullname
            playerCell.playerRole.text = teamLineup[indexPath.row].position?.name
            playerCell.playerImage.sd_setImage(
                with: URL(string: teamLineup[indexPath.row].image_path ?? ""),
                placeholderImage: UIImage(named: "person2")
            )
        }
        return playerCell
    }
    
}

extension SquadViewController: UITableViewDelegate {
    
}
