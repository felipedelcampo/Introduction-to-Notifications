//
//  LocalNotificationiOS9.swift
//  Introduction to Notifications
//
//  Created by Pedro Moitinho on 27/11/17.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit

class LocalNotificationiOS9: LocalNotificationProtocol {
    
    func requestAuthorization(completionHandler: @escaping (Bool) -> Swift.Void) {
        
        let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: [])
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
        notificationsDetermined = true
    }
    
    func getNotificationSettings(completionHandler: @escaping (Bool?) -> Swift.Void) {
        
        if notificationsDetermined {
            completionHandler(UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false)
        } else {
            completionHandler(nil)
        }
    }
    
    func scheduleNotification(notificationItem: LocalNotificationItem, completionHandler: ((Error?) -> Swift.Void)?) {
        
        let notification = UILocalNotification()
        notification.alertTitle = notificationItem.title
        
        var alertBody: String?
        if let subtitle = notificationItem.body {
            alertBody = subtitle + "\n"
        }
        if let body = notificationItem.body {
            alertBody = alertBody ?? "" + body
        }
        notification.alertBody = alertBody
        
        notification.fireDate = notificationItem.triggerDate
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.shared.scheduleLocalNotification(notification)
        
        completionHandler?(nil)
    }
    
    func getPendingNotificationRequests(completionHandler: @escaping ([LocalNotificationItem]) -> Swift.Void) {
        
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else {
            completionHandler([])
            return
        }
        
        var notificationItems: [LocalNotificationItem] = []
        for notification in notifications {
            
            if let triggerDate = notification.fireDate {
                let notificationItem = LocalNotificationItem(title: notification.alertTitle,
                                                             subtitle: nil,
                                                             body: notification.alertBody,
                                                             triggerDate: triggerDate)
                
                notificationItems.append(notificationItem)
            }
        }
        
        completionHandler(notificationItems)
    }
    
    func getDeliveredNotifications(completionHandler: @escaping ([LocalNotificationItem]) -> Swift.Void) {
        
        completionHandler([])
    }
    
    func removeNotificationList(items: [LocalNotificationItem]) {
        
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else { return }
        
        for notification in notifications {
            for notificationItem in items {
                if notification.alertTitle == notificationItem.title, notification.alertBody == notificationItem.body, notification.fireDate == notificationItem.triggerDate {
                    UIApplication.shared.cancelLocalNotification(notification)
                }
            }
        }
    }
    
    func removeAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    fileprivate var notificationsDetermined: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "notificationsDeterminedKey")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "notificationsDeterminedKey")
            UserDefaults.standard.synchronize()
        }
    }
}
