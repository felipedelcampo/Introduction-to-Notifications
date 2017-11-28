//
//  LocalNotificationiOS10.swift
//  Introduction to Notifications
//
//  Created by Pedro Moitinho on 27/11/17.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit
import UserNotifications

@available(iOS 10.0, *)
class LocalNotificationiOS10: LocalNotificationProtocol {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization(completionHandler: @escaping (Bool) -> Swift.Void) {
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { accepted, error in
            
            DispatchQueue.main.async {
                completionHandler(accepted)
            }
        }
    }
    
    func getNotificationSettings(completionHandler: @escaping (Bool?) -> Swift.Void) {
        
        notificationCenter.getNotificationSettings { settings in
            
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    completionHandler(true)
                case .denied:
                    completionHandler(false)
                case .notDetermined:
                    completionHandler(nil)
                }
            }
        }
    }
    
    func scheduleNotification(notificationItem: LocalNotificationItem, completionHandler: ((Error?) -> Swift.Void)?) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: notificationItem.triggerDate)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        
        if let title = notificationItem.title {
            content.title = title
        }
        
        if let subtitle = notificationItem.subtitle {
            content.subtitle = subtitle
        }
        
        if let body = notificationItem.body {
            content.body = body
        }
        
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: notificationItem.identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            DispatchQueue.main.async {
                completionHandler?(error)
            }
        }
    }
    
    func getPendingNotificationRequests(completionHandler: @escaping ([LocalNotificationItem]) -> Swift.Void) {
        
        notificationCenter.getPendingNotificationRequests { requests in
            
            var notificationItems: [LocalNotificationItem] = []
            for request in requests {
                
                if  let trigger = request.trigger as? UNCalendarNotificationTrigger,
                    let triggerDate = trigger.nextTriggerDate() {
                    
                let notificationItem = LocalNotificationItem(identifier: request.identifier,
                                                             title: request.content.title,
                                                             subtitle: request.content.subtitle,
                                                             body: request.content.body,
                                                             triggerDate: triggerDate)
                    
                    notificationItems.append(notificationItem)
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(notificationItems)
            }
        }
    }
    
    func getDeliveredNotifications(completionHandler: @escaping ([LocalNotificationItem]) -> Swift.Void) {
        
        notificationCenter.getDeliveredNotifications { notifications in
            
            var notificationItems: [LocalNotificationItem] = []
            for notification in notifications {
                    
                let notificationItem = LocalNotificationItem(identifier: notification.request.identifier,
                                                            title: notification.request.content.title,
                                                            subtitle: notification.request.content.subtitle,
                                                            body: notification.request.content.body,
                                                            triggerDate: notification.date)
                    
                    notificationItems.append(notificationItem)
            }
            
            DispatchQueue.main.async {
                completionHandler(notificationItems)
            }
        }
    }
    
    func removeNotificationList(items: [LocalNotificationItem]) {
        
        let identifierList = items.map { $0.identifier }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifierList)
        notificationCenter.removeDeliveredNotifications(withIdentifiers: identifierList)
    }
    
    func removeAllNotifications() {
        
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
}
