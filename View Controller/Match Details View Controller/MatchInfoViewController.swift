//
//  MatchInfoViewController.swift
//  cricArena
//
//  Created by bjit on 17/2/23.
//

import UIKit
import Combine
class MatchInfoViewController: UIViewController {
    @IBOutlet weak var matchInfoTable: UITableView!
    private var cancellables: Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        matchInfoTable.dataSource = self
        matchInfoTable.delegate = self
        configureInfoCell()
        binder()
        matchInfoTable.sectionHeaderTopPadding = 0
        matchInfoTable.reloadData()
    }
    func configureInfoCell(){
        let infoNib = UINib(nibName: "MatchInfoTableViewCell", bundle: nil)
        matchInfoTable.register(infoNib, forCellReuseIdentifier: "MatchInfoTableViewCell")
    }
    func binder() {
        MatchDetailsViewController.matchDetailsViewModel.$matchInfo.sink { [weak self] _ in
            
            DispatchQueue.main.async {
                self?.matchInfoTable.reloadData()
            }
            
        }.store(in: &cancellables)
    }
}
extension MatchInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let basicInfoCell = tableView.dequeueReusableCell(withIdentifier: "MatchInfoTableViewCell", for: indexPath) as? MatchInfoTableViewCell
            guard let basicInfoCell = basicInfoCell else {return UITableViewCell()}
            basicInfoCell.caption.text = MatchDetailsViewController.matchDetailsViewModel.matchDetails?.league?.name
            basicInfoCell.subCaption.text = MatchDetailsViewController.matchDetailsViewModel.matchDetails?.stage?.name
            let dateTime = sharedData().covertingDateTime(data: MatchDetailsViewController.matchDetailsViewModel.matchDetails?.starting_at ?? "")
            basicInfoCell.matchInfoDate.text = "Time: " + dateTime.1 + ", " + dateTime.0
            let dateTimeString = "Time: \(dateTime.1), \(dateTime.0)"
            let attributedText = NSMutableAttributedString(string: dateTimeString)
            let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
            let range = (dateTimeString as NSString).range(of: "Time:")
            attributedText.addAttributes(boldFontAttribute, range: range)
            basicInfoCell.matchInfoDate.attributedText = attributedText
            basicInfoCell.matchInfoImage.sd_setImage(
                with: URL(string: MatchDetailsViewController.matchDetailsViewModel.matchDetails?.league?.image_path ?? ""),
                placeholderImage: UIImage(named: "ind")
            )
            return basicInfoCell
        case 1:
            let venueCell = tableView.dequeueReusableCell(withIdentifier: "MatchInfoTableViewCell", for: indexPath) as? MatchInfoTableViewCell
            guard let venueCell = venueCell else {return UITableViewCell()}
            let venueString = "Venue: \(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.venue?.name ?? "")"
            let attributedVenueText = NSMutableAttributedString(string: venueString)
            let boldVenueFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
            let venueRange = (venueString as NSString).range(of: "Venue:")
            attributedVenueText.addAttributes(boldVenueFontAttribute, range: venueRange)
            venueCell.caption.attributedText = attributedVenueText
            let cityString = "City: \(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.venue?.city ?? "")"
            let attributedCityText = NSMutableAttributedString(string: cityString)
            let boldCityFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
            let cityRange = (cityString as NSString).range(of: "City:")
            attributedCityText.addAttributes(boldCityFontAttribute, range: cityRange)
            venueCell.subCaption.attributedText = attributedCityText
            venueCell.matchInfoImage.sd_setImage(with: URL(string: MatchDetailsViewController.matchDetailsViewModel.matchDetails?.venue?.image_path ?? ""), placeholderImage: UIImage(named: "venue"))
            venueCell.matchInfoDate.text = ""
            return venueCell
        case 2:
            let matchResultCell = tableView.dequeueReusableCell(withIdentifier: "MatchInfoTableViewCell", for: indexPath) as? MatchInfoTableViewCell
            guard let matchResultCell = matchResultCell else {return UITableViewCell()}
            let resultString = "Result: \(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.note ?? "")"
            let attributedResultText = NSMutableAttributedString(string: resultString)
            let boldResultFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
            let resultRange = (resultString as NSString).range(of: "Result:")
            attributedResultText.addAttributes(boldResultFontAttribute, range: resultRange)
            matchResultCell.subCaption.attributedText = attributedResultText
            matchResultCell.matchInfoImage.image = UIImage(named: "trophy")
            if MatchDetailsViewController.matchDetailsViewModel.matchDetails?.status == "NS" {
                let notStartedString = "Result: Match has not started yet!"
                let attributedNotStartedText = NSMutableAttributedString(string: notStartedString)
                attributedNotStartedText.addAttributes(boldResultFontAttribute, range: (notStartedString as NSString).range(of: "Result:"))
                matchResultCell.subCaption.attributedText = attributedNotStartedText
            }
            matchResultCell.caption.text = ""
            matchResultCell.matchInfoDate.text = ""
            return matchResultCell
        case 3:
            let tossResultCell = tableView.dequeueReusableCell(withIdentifier: "MatchInfoTableViewCell", for: indexPath) as? MatchInfoTableViewCell
            guard let tossResultCell = tossResultCell else {return UITableViewCell()}
            let tossString = "Toss: \(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.tosswon?.name ?? "") Won the Toss and decided \(MatchDetailsViewController.matchDetailsViewModel.matchDetails?.elected ?? "")"
            let attributedTossText = NSMutableAttributedString(string: tossString)
            let boldTossFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
            let tossRange = (tossString as NSString).range(of: "Toss:")
            attributedTossText.addAttributes(boldTossFontAttribute, range: tossRange)
            tossResultCell.subCaption.attributedText = attributedTossText
            
            tossResultCell.matchInfoImage.image = UIImage(named: "coin-toss")
            if MatchDetailsViewController.matchDetailsViewModel.matchDetails?.status == "NS" {
                let notHeldString = "Toss: Toss has not been held yet!"
                let attributedNotHeldText = NSMutableAttributedString(string: notHeldString)
                attributedNotHeldText.addAttributes(boldTossFontAttribute, range: (notHeldString as NSString).range(of: "Toss:"))
                tossResultCell.subCaption.attributedText = attributedNotHeldText
            }
            tossResultCell.caption.text = ""
            tossResultCell.matchInfoDate.text = ""
            return tossResultCell
        case 4:
            let manOfMatchCell = tableView.dequeueReusableCell(withIdentifier: "MatchInfoTableViewCell", for: indexPath) as? MatchInfoTableViewCell
            guard let manOfMatchCell = manOfMatchCell else {return UITableViewCell()}
            // Create a attributed string with bold text
            let boldAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
            let attributedString = NSMutableAttributedString(string: "Man of the Match : ", attributes: nil)
            attributedString.addAttributes(boldAttributes, range: NSRange(location: 0, length: 17))
            
            if MatchDetailsViewController.matchDetailsViewModel.matchDetails?.status == "NS" {
                manOfMatchCell.subCaption.text = "Man of the Match are not decided yet"
            } else {
                manOfMatchCell.subCaption.text = MatchDetailsViewController.matchDetailsViewModel.matchDetails?.manofmatch?.fullname
            }
            manOfMatchCell.caption.attributedText = attributedString
            manOfMatchCell.matchInfoImage.sd_setImage(with: URL(string: MatchDetailsViewController.matchDetailsViewModel.matchDetails?.manofmatch?.image_path ?? ""),
                placeholderImage: UIImage(named: "person2"))
            manOfMatchCell.matchInfoDate.text = ""
            return manOfMatchCell
        default:
            return UITableViewCell()
        }
    }
}
extension MatchInfoViewController: UITableViewDelegate {
    
}


