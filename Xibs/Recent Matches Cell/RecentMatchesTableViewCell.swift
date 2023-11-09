//
//  RecentMatchesTableViewCell.swift
//  cricArena
//
//  Created by bjit on 14/2/23.
//

import UIKit
import SDWebImage

class RecentMatchesTableViewCell: UITableViewCell {
    @IBOutlet weak var tournamentName: UILabel!
    @IBOutlet weak var homeTeamFlag: UIImageView!
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var homeTeamRun: UILabel!
    @IBOutlet weak var homeTeamOver: UILabel!
    @IBOutlet weak var matchResult: UILabel!
    @IBOutlet weak var matchDate: UILabel!
    @IBOutlet weak var awayTeamFlag: UIImageView!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var awayTeamRun: UILabel!
    @IBOutlet weak var awayTeamOver: UILabel!
    @IBOutlet weak var vsLayout: UILabel!
    @IBOutlet weak var recentMatchesView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recentMatchesView.layer.cornerRadius = 10
        recentMatchesView.layer.shadowColor = UIColor.black.cgColor
        recentMatchesView.layer.shadowOpacity = 0.5
        recentMatchesView.layer.shadowOffset = CGSize(width: 0, height: 2)
        recentMatchesView.layer.shadowRadius = 2
        recentMatchesView.layer.masksToBounds = false
        vsLayout.layer.cornerRadius = 0.5 * vsLayout.bounds.size.width
        vsLayout.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func setMatch(matchInfo: Match) {
        tournamentName.text = matchInfo.round
        homeTeamName.text = matchInfo.localteam?.code
        awayTeamName.text = matchInfo.visitorteam?.code
        homeTeamFlag.sd_setImage(
            with: URL(string: matchInfo.localteam?.image_path ?? ""),
            placeholderImage: UIImage(named: "ban")
        )
        
        awayTeamFlag.sd_setImage(
            with: URL(string: matchInfo.visitorteam?.image_path ?? ""),
            placeholderImage: UIImage(named: "ind")
        )
        if matchInfo.runs.count != 0 {
            if(matchInfo.visitorteam?.id == matchInfo.runs[0].team_id) {
                awayTeamRun.text = "\(matchInfo.runs[0].score ?? 0)" + "/ " + "\(matchInfo.runs[0].wickets ?? 0)"
                awayTeamOver.text = "(" + "\(matchInfo.runs[0].overs ?? 0.0)" + ")"
                homeTeamRun.text = "\(matchInfo.runs[1].score ?? 0)" + "/ " + "\(matchInfo.runs[1].wickets ?? 0)"
                homeTeamOver.text = "(" + "\(matchInfo.runs[1].overs ?? 0.0)" + ")"
            }
            else {
                awayTeamRun.text = "\(matchInfo.runs[1].score ?? 0)" + "/ " + "\(matchInfo.runs[1].wickets ?? 0)"
                awayTeamOver.text = "(" + "\(matchInfo.runs[1].overs ?? 0.0)" + ")"
                
                homeTeamRun.text = "\(matchInfo.runs[0].score ?? 0)" + "/ " + "\(matchInfo.runs[0].wickets ?? 0)"
                homeTeamOver.text = "(" + "\(matchInfo.runs[0].overs ?? 0.0)" + ")"
            }
        }
        matchResult.text = matchInfo.note
        let recentMatchdateTime = sharedData().covertingDateTime(data: matchInfo.starting_at ?? "")
        matchDate.text = recentMatchdateTime.1
        
    }
}
