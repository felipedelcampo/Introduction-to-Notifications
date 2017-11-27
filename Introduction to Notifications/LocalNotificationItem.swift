//
//  LocalNotificationItem.swift
//  Introduction to Notifications
//
//  Created by Pedro Moitinho on 27/11/17.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit

struct LocalNotificationItem {
    
    var title: String?
    var subtitle: String?
    var body: String?
    var triggerDate: Date
    var identifier: String { return String(format: "%d", triggerDate.timeIntervalSince1970) }
}
