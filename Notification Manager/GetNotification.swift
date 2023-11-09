//
//  GetNotification.swift
//  cricArena
//
//  Created by bjit on 25/2/23.
//

import Foundation
import UserNotifications

class getNotification {
   static func scheduleNotification(title: String, body: String, matchStartTime: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let timeDifference = matchStartTime.timeIntervalSince(Date())
        let notificationTime = max(0, timeDifference - 10 * 60) //Subtract 10 minutes
       guard notificationTime > 0 else {
           return
       }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTime, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                //print("Error scheduling notification: \(error.localizedDescription)")
            } else {
               // print("Notification scheduled successfully")
            }
        }
    }
}
