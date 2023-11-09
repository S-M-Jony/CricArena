//
//  Shared.swift
//  cricArena
//
//  Created by bjit on 14/2/23.
//

import Foundation
import UIKit
import SystemConfiguration

class sharedData {
    func covertingDateTime(data: String) -> (String,String) {
        let dateString = data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid Date")
            return("","")
        }
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.day,.month,.year], from: date)
        let month = calender.monthSymbols[dateComponents.month! - 1]
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let time = dateFormatter.string(from: date)
        let expectedDateFormat = "\(dateComponents.day!) \(month)"
        return(time,expectedDateFormat)
    }
}
class CustomizedTabBar: UITabBar {
    override func draw(_ rect: CGRect) {
        let inset: CGFloat = 0
        let safeAreaInsets = self.safeAreaInsets
        let height = self.bounds.height
        let insetBounds = CGRect(x: 6 * inset, y: inset, width: self.bounds.width - 12 * inset, height: height - 2 * inset)
        let path = UIBezierPath(roundedRect: insetBounds, cornerRadius: 0)
        let bgcolor = UIColor(hex: 0x272343)
        bgcolor.setFill()
        path.fill()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let safeAreaInsets = self.safeAreaInsets
        let height = self.bounds.height
        var tabBarItemIndex = 0
        for _ in self.items! {
            let tabBarButton = self.subviews[tabBarItemIndex]
            let y = (height - tabBarButton.bounds.height) / 2
            tabBarButton.frame = CGRect(x: tabBarButton.frame.origin.x, y: y, width: tabBarButton.bounds.width, height: tabBarButton.bounds.height)
            tabBarItemIndex += 1
        }
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        unselectedItemTintColor = UIColor(hex:0x829460)
    }
}

class internetCheck {
  static let shared = internetCheck()
    private init(){}
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

