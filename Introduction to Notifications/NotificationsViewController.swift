//
//  ViewController.swift
//  Introduction to Notifications
//
//  Created by Pedro Moitinho on 24/11/17.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UITableViewController {
    
    var pendingNotificationRequests: [UNNotificationRequest] = []
    var deliveredNotifications: [UNNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNotifications()
    }
    
    @IBAction func cleanAllNotifications(_ sender: Any) {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        fetchNotifications()
    }
    
    private func fetchNotifications() {
        
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            
            self.deliveredNotifications = notifications
            
            UNUserNotificationCenter.current().getPendingNotificationRequests() { requests in
                
                self.pendingNotificationRequests = requests
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return pendingNotificationRequests.count
        case 1:
            return deliveredNotifications.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 10
        cell.selectionStyle = .none
        
        var title = ""
        var subtitle = ""
        var body = ""
        var date = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm:ss"
        
        switch indexPath.section {
        case 0:
            let request = pendingNotificationRequests[indexPath.row]
            let content = request.content
            title = content.title
            subtitle = content.subtitle
            body = content.body
            let trigger = request.trigger as? UNCalendarNotificationTrigger
            date = dateFormatter.string(from: trigger!.nextTriggerDate()!)
        case 1:
            let notification = deliveredNotifications[indexPath.row]
            let content = notification.request.content
            title = content.title
            subtitle = content.subtitle
            body = content.body
            date = dateFormatter.string(from: notification.date)
        default:
            break
        }
        
        cell.textLabel?.text = String(format: "Title: %@ \nSubtitle: %@ \nBody: %@ \nDate: %@", title, subtitle, body, date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pending Notification"
        case 1:
            return "Delivered Notifications"
        default:
            return nil
        }
    }
}

extension NotificationsViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        fetchNotifications()
        completionHandler([.alert, .sound])
    }
}
