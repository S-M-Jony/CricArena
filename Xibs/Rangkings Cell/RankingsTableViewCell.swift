//
//  RankingsTableViewCell.swift
//  cricArena
//
//  Created by bjit on 21/2/23.
//

import UIKit
import SDWebImage
class RankingsTableViewCell: UITableViewCell {
    @IBOutlet weak var RankingImage: UIImageView!
    @IBOutlet weak var rankingName: UILabel!
    @IBOutlet weak var rankingPosition: UILabel!
    @IBOutlet weak var rankingView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rankingView.cornerRadius()
        rankingView.shadow()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setRank(teamInfo: TeamInfo) {
        rankingPosition.text = String(teamInfo.position!)
        rankingName.text = teamInfo.name
        RankingImage.sd_setImage(
            with: URL(string: teamInfo.image_path ?? ""),
            placeholderImage: UIImage(named:"person2")
        )
    }
}
