//
//  MatchInfoTableViewCell.swift
//  cricArena
//
//

import UIKit
class MatchInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var matchInfoImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var subCaption: UILabel!
    @IBOutlet weak var matchInfoDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        matchInfoImage.layer.cornerRadius = 10
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
