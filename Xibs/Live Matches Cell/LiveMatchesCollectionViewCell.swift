//
//  LiveMatchesCollectionViewCell.swift
//  cricArena
//
//  Created by bjit on 13/2/23.
//

import UIKit
class LiveMatchesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var liveMatchBackView: UIView!
    @IBOutlet weak var tournamentName: UILabel!
    @IBOutlet weak var homeTeamFlag: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var homeTeamRun: UILabel!
    @IBOutlet weak var homeTeamOver: UILabel!
    @IBOutlet weak var VsButton: UIButton!
    @IBOutlet weak var awayTeamFlag: UIImageView!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var awayTeamRun: UILabel!
    @IBOutlet weak var awayTeamOver: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setMatch(matchInfo: Match) {
        tournamentName.text = matchInfo.type
        homeTeamName.text = matchInfo.localteam?.code
        awayTeamName.text = matchInfo.visitorteam?.code
        if matchInfo.runs.isEmpty {
            homeTeamFlag.isHidden = true
            awayTeamFlag.isHidden = true
            homeTeamRun.isHidden = true
            homeTeamOver.isHidden = true
            awayTeamRun.isHidden = true
            awayTeamOver.isHidden = true
            homeTeamFlag.sd_setImage(
                with: URL(string: matchInfo.localteam?.image_path ?? ""),
                placeholderImage: UIImage(named: "ban")
            )
            awayTeamFlag.sd_setImage(
                with: URL(string: matchInfo.localteam?.image_path ?? ""),
                placeholderImage: UIImage(named: "ind")
            )
        }
    }
}
