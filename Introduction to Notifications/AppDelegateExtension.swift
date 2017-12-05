//
//  AppDelegateExtension.swift
//  Introduction to Notifications
//
//  Created by Felipe Del Campo Gomes dos Santos on 05/12/2017.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit
import UserNotifications

// iOS 10
@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        let alert = UIAlertController(title: "NotificationCenter did receive notification.", message: response.actionIdentifier, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        window?.rootViewController?.present(alert, animated: true)
    }
}
