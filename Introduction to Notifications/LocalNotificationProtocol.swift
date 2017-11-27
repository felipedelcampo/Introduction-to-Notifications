//
//  LocalNotificationProtocol.swift
//  Introduction to Notifications
//
//  Created by Pedro Moitinho on 27/11/17.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit

protocol LocalNotificationProtocol {
    
    func requestAuthorization(completionHandler: @escaping (Bool) -> Swift.Void)
    func getNotificationSettings(completionHandler: @escaping (Bool?) -> Swift.Void)
    func scheduleNotification(notificationItem: LocalNotificationItem, completionHandler: ((Error?) -> Swift.Void)?)
    func getPendingNotificationRequests(completionHandler: @escaping ([LocalNotificationItem]) -> Swift.Void)
    func getDeliveredNotifications(completionHandler: @escaping ([LocalNotificationItem]) -> Swift.Void)
    func removeNotificationList(items: [LocalNotificationItem])
    func removeAllNotifications()
}