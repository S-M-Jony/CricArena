//
//  ScoreCardViewController.swift
//  cricArena
//
//  Created by bjit on 17/2/23.
//

import UIKit
import Combine
class ScoreCardViewController: UIViewController {
    @IBOutlet weak var teamSegmentController: UISegmentedControl!
    @IBOutlet weak var scoreTableView: UITableView!
    @IBOutlet weak var scorecardView: UIView!
    private var cancellables: Set<AnyCancellable> = []
    let scoreCardViewModel = ScoreCardViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
        scoreCardHeader()
        scoreCardCell()
        binder()
    }
    func scoreCardHeader(){
        let headerNib = UINib(nibName: "ScoreCardTVHeaderView", bundle: nil)
        scoreTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ScoreCardTVHeaderView")
    }
    func scoreCardCell(){
        let infoNib = UINib(nibName: "ScoreCardTableViewCell", bundle: nil)
        scoreTableView.register(infoNib, forCellReuseIdentifier: "ScoreCardTableViewCell")
    }
    func binder() {
        MatchDetailsViewController.matchDetailsViewModel.$matchInfo.sink { [weak self] matchData in
            guard let self = self else {return}
            guard let matchData = matchData else {return}
            DispatchQueue.main.async {
                self.configureTeamSegment()
            }
            
            self.scoreCardViewModel.prepareTeamWiseScoreData(teamId: matchData.localteam?.id ?? 0)
        }.store(in: &cancellables)
        
        scoreCardViewModel.$teamBattingDetails.sink { [weak self] batting in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.scoreTableView.reloadSections([0,1], with: .automatic)
            }
        }.store(in: &cancellables)
    }
    func configureTeamSegment(){
        teamSegmentController.setTitle(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.localteam?.name, forSegmentAt: 0)
        teamSegmentController.setTitle(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.visitorteam?.name, forSegmentAt: 1)
    }
    @IBAction func teamSegmentControllerAction(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            scoreCardViewModel.prepareTeamWiseScoreData(teamId: MatchDetailsViewController.matchDetailsViewModel.matchDetails?.localteam?.id ?? 0)
        case 1:
            scoreCardViewModel.prepareTeamWiseScoreData(teamId: MatchDetailsViewController.matchDetailsViewModel.matchDetails?.visitorteam?.id ?? 0)
        default:
            break
        }
    }
}
extension ScoreCardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return scoreCardViewModel.teamBattingDetails?.count ?? 0
            
        } else {
            return scoreCardViewModel.teamBowlingDetails?.count ?? 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let batsmanCell = scoreTableView.dequeueReusableCell(withIdentifier: "ScoreCardTableViewCell", for: indexPath) as? ScoreBoardBodyTableViewCell
            guard let batsmanCell = batsmanCell else {return UITableViewCell()}
            batsmanCell.playerName.text = scoreCardViewModel.teamBattingDetails?[indexPath.row].batsman?.fullname
            batsmanCell.outInfo.text = scoreCardViewModel.teamBattingDetails?[indexPath.row].result?.name
            batsmanCell.score1.text = String(scoreCardViewModel.teamBattingDetails?[indexPath.row].score ?? 0)
            batsmanCell.score2.text = String(scoreCardViewModel.teamBattingDetails?[indexPath.row].ball ?? 0)
            batsmanCell.score3.text = String(scoreCardViewModel.teamBattingDetails?[indexPath.row].four_x ?? 0)
            batsmanCell.score4.text = String(scoreCardViewModel.teamBattingDetails?[indexPath.row].six_x ?? 0)
            batsmanCell.score5.text = String(scoreCardViewModel.teamBattingDetails?[indexPath.row].rate ?? 0)
            return batsmanCell
        case 1:
            let bowlerCell = scoreTableView.dequeueReusableCell(withIdentifier: "ScoreCardTableViewCell", for: indexPath) as? ScoreBoardBodyTableViewCell
            guard let bowlerCell = bowlerCell else {return UITableViewCell()}
            bowlerCell.playerName.text = scoreCardViewModel.teamBowlingDetails?[indexPath.row].bowler?.fullname
            bowlerCell.outInfo.text = ""
            bowlerCell.score1.text = String(scoreCardViewModel.teamBowlingDetails?[indexPath.row].overs ?? 0)
            bowlerCell.score2.text = String(scoreCardViewModel.teamBowlingDetails?[indexPath.row].medians ?? 0)
            bowlerCell.score3.text = String(scoreCardViewModel.teamBowlingDetails?[indexPath.row].runs ?? 0)
            bowlerCell.score4.text = String(scoreCardViewModel.teamBowlingDetails?[indexPath.row].wickets ?? 0)
            bowlerCell.score5.text = String(scoreCardViewModel.teamBowlingDetails?[indexPath.row].rate ?? 0)
            return bowlerCell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0
        {
            let batsmanSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ScoreCardTVHeaderView") as! ScoreCardTVHeaderView
            batsmanSectionHeader.playerType.text = "Batsman"
            batsmanSectionHeader.scoreType1.text = "R"
            batsmanSectionHeader.scoreType2.text = "B"
            batsmanSectionHeader.scoreType3.text = "4s"
            batsmanSectionHeader.scoreType4.text = "6s"
            batsmanSectionHeader.scoreType5.text = "S/R"
            return batsmanSectionHeader
        }
        else if section == 1
        {
            let bowlingSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier:"ScoreCardTVHeaderView") as! ScoreCardTVHeaderView
            bowlingSectionHeader.playerType.text = "Bowler"
            bowlingSectionHeader.scoreType1.text = "O"
            bowlingSectionHeader.scoreType2.text = "M"
            bowlingSectionHeader.scoreType3.text = "R"
            bowlingSectionHeader.scoreType4.text = "W"
            bowlingSectionHeader.scoreType5.text = "E/R"
            return bowlingSectionHeader
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
extension ScoreCardViewController: UITableViewDelegate {
    
}
