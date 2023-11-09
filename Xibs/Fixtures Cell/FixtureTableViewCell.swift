//
//  FixtureTableViewCell.swift
//  cricArena
//
//  Created by Shahnewaz on 22/2/23.
//

import UIKit

class FixtureTableViewCell: UITableViewCell {
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var upcomingStatus: UILabel!
    @IBOutlet weak var homeTeamFlag: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamFlag: UIImageView!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var fixturesCell: UIView!
    @IBOutlet weak var VsLayout: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        fixturesCell.cornerRadius()
        fixturesCell.shadow()
        VsLayout.layer.cornerRadius = 0.5 * VsLayout.bounds.size.width
        VsLayout.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setMatch(matchInfo: Match) {
        leagueName.text = matchInfo.round
        homeTeamName.text = matchInfo.localteam?.code
        awayTeamName.text = matchInfo.visitorteam?.code
        let fixturedateTime = sharedData().covertingDateTime(data: matchInfo.starting_at)
        matchDate.text = fixturedateTime.1 + ", " + fixturedateTime.0
        homeTeamFlag.sd_setImage(
            with: URL(string: matchInfo.localteam?.image_path ?? ""),
            placeholderImage: UIImage(named: "ban")
        )
        awayTeamFlag.sd_setImage(
            with: URL(string: matchInfo.visitorteam?.image_path ?? ""),
            placeholderImage: UIImage(named: "ind")
        )
    }
}
