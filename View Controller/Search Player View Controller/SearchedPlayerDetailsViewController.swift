//
//  SearchedPlayerDetailsViewController.swift
//  cricArena
//
//  Created by bjit on 21/2/23.
//

import UIKit
import Combine
class SearchedPlayerDetailsViewController: UIViewController {
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var battingStyle: UILabel!
    @IBOutlet weak var bowlingStyle: UILabel!
    @IBOutlet weak var role: UILabel!
    private var cancellables: Set<AnyCancellable> = []
    var searchedPlayerListViewModel = SearchedPlayerListViewModel()
    var trappedPlayerId: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchedPlayerListViewModel.getPlayerDetails(playerId: trappedPlayerId!)
        binder()
        if !internetCheck.shared.isInternetAvailable() {
            let alert = UIAlertController(title: "No Internet Connection",
                                          message: "Please check your internet connection and restart CricTracker.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func binder() {
        searchedPlayerListViewModel.$playerDetails.sink { [weak self] data in
            DispatchQueue.main.async {
                print("searched player binder")
                let boldFont = UIFont.boldSystemFont(ofSize: 17)
                self?.firstName.attributedText = attributedString(for: "First Name : ", boldText: data?.firstname ?? "", font: boldFont)
                self?.lastName.attributedText = attributedString(for: "First Name : ", boldText: data?.lastname ?? "", font: boldFont)
                self?.fullName.attributedText = attributedString(for: "FullName : ", boldText: data?.fullname ?? "", font: boldFont)
                self?.playerImage.sd_setImage(
                    with: URL(string: data?.image_path ?? ""),
                    placeholderImage: UIImage(named:"person2")
                )
                self?.birthDate.attributedText = attributedString(for: "Date Of Birth : ", boldText: data?.dateofbirth ?? "", font: boldFont)
                self?.battingStyle.attributedText = attributedString(for: "Batting Style : ", boldText: data?.battingstyle ?? "", font: boldFont)
                self?.bowlingStyle.attributedText = attributedString(for: "Bowling Style : ", boldText: data?.bowlingstyle ?? "", font: boldFont)
                self?.role.attributedText = attributedString(for: "Role : ", boldText: data?.position?.name ?? "", font: boldFont)
                func attributedString(for prefix: String, boldText: String, font: UIFont) -> NSAttributedString {
                    let attributedString = NSMutableAttributedString(string: prefix + boldText)
                    attributedString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: prefix.count, length: boldText.count))
                    return attributedString
                }
            }
        }.store(in: &cancellables)
    }
}
