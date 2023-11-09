//
//  MatchDetailsViewController.swift
//  cricArena
//
//  Created by bjit on 17/2/23.
//

import UIKit
import Combine
import SDWebImage
class MatchDetailsViewController: UIViewController {
    @IBOutlet weak var tournamentname: UILabel!
    @IBOutlet weak var homeTeamFlag: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var VsLayout: UILabel!
    @IBOutlet weak var awayTeamFlag: UIImageView!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var matchinfo: UIView!
    @IBOutlet weak var scorecard: UIView!
    @IBOutlet weak var detailsHeaderView: UIView!
    @IBOutlet weak var squad: UIView!
    @IBOutlet weak var detailsSegmentBg: UIView!
    @IBOutlet weak var detailsSegment: UISegmentedControl!
    var trappedMatchId: Int?
    static var matchDetailsViewModel = MatchDetailsViewModel()
    private var cancellables: Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsSegmentBg.cornerRadius()
        detailsSegmentBg.shadow()
        detailsHeaderView.shadow()
        VsLayout.layer.cornerRadius = 0.5 * VsLayout.bounds.size.width
        VsLayout.clipsToBounds = true
        MatchDetailsViewController.matchDetailsViewModel.fetchMatchDetails(matchId: trappedMatchId ?? 120)
        binder()
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        detailsSegment.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        let unselectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        detailsSegment.setTitleTextAttributes(unselectedTitleTextAttributes, for: .normal)
    }
    @IBAction func containerSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            scorecard.alpha = 0
            matchinfo.alpha = 1
            squad.alpha = 0
        case 1:
            scorecard.alpha = 1
            matchinfo.alpha = 0
            squad.alpha = 0
        case 2:
            scorecard.alpha = 0
            matchinfo.alpha = 0
            squad.alpha = 1
        default:
            break
        }
    }
    
    func binder() {
        MatchDetailsViewController.matchDetailsViewModel.$matchDetails.sink { [weak self] matchDetails in
            guard let matchDetails = matchDetails else  { return }
            dump(matchDetails)
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.tournamentname.text = matchDetails.league?.name
                self.homeTeamName.text = matchDetails.localteam?.name
                self.awayTeamName.text = matchDetails.visitorteam?.name
                self.homeTeamFlag.sd_setImage(
                    with: URL(string: matchDetails.localteam?.image_path ?? ""),
                    placeholderImage: UIImage(named: "ban")
                )
                
                self.awayTeamFlag.sd_setImage(
                    with: URL(string: matchDetails.visitorteam?.image_path ?? ""),
                    placeholderImage: UIImage(named: "ind")
                )
            }
            
        }.store(in: &cancellables)
    }
}
