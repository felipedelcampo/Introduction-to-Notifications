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
    
    var localNotification: LocalNotificationProtocol?
    var pendingNotificationRequests: [LocalNotificationItem] = []
    var deliveredNotifications: [LocalNotificationItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            localNotification = LocalNotificationiOS10()
            UNUserNotificationCenter.current().delegate = self
        } else {
            localNotification = LocalNotificationiOS9()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchNotifications()
    }
    
    @IBAction func didTouchTrashButton(_ sender: Any? = nil) {
        
        localNotification?.removeAllNotifications()
        fetchNotifications()
    }
    
    @IBAction func didTouchNewNotificationButton(_ sender: Any? = nil) {
        
        localNotification?.getNotificationSettings { authorizationStatus in
            
            if authorizationStatus == true {
                
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: NotificationDetailsViewController.self)) else {
                    return
                }
                
                self.navigationController?.pushViewController(controller, animated: true)
            } else if authorizationStatus == false {
                
                let alert = UIAlertController(title: "Error!", message: "Autho", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            } else {
                
                self.localNotification?.requestAuthorization { _ in
                    
                    self.didTouchNewNotificationButton()
                }
            }
        }
    }
    
    private func fetchNotifications() {
        
        localNotification?.getDeliveredNotifications { notifications in
            
            self.deliveredNotifications = notifications
            
            self.localNotification?.getPendingNotificationRequests { requests in
                
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
        
        var notificationItem: LocalNotificationItem?
        
        if indexPath.section ==  0 {
            notificationItem = pendingNotificationRequests[indexPath.row]
        } else if indexPath.section ==  1 {
            notificationItem = deliveredNotifications[indexPath.row]
        }
        
        cell.textLabel?.text = ""
        if let title = notificationItem?.title {
            cell.textLabel?.text? += String(format: "Title: %@", title)
        }
        if let subtitle = notificationItem?.subtitle {
            cell.textLabel?.text? += String(format: "\nSubtitle: %@", subtitle)
        }
        if let body = notificationItem?.body {
            cell.textLabel?.text? += String(format: "\nBody: %@", body)
        }
        if let date = notificationItem?.triggerDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy hh:mm:ss"
            cell.textLabel?.text? += String(format: "\nDate: %@", dateFormatter.string(from: date))
        }
        
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if #available(iOS 10.0, *) {
            
            let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { action, indexPath in
                
                var notificationItem: LocalNotificationItem?
                if indexPath.section ==  0 {
                    notificationItem = self.pendingNotificationRequests[indexPath.row]
                } else if indexPath.section ==  1 {
                    notificationItem = self.deliveredNotifications[indexPath.row]
                }
                
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: NotificationDetailsViewController.self)) as? NotificationDetailsViewController else {
                    return
                }
                
                controller.notificationItem = notificationItem
                self.navigationController?.pushViewController(controller, animated: true)
            })
            editAction.backgroundColor = UIColor.blue
            
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { action, indexPath in
                
                var items: [LocalNotificationItem] = []
                if indexPath.section ==  0 {
                    items.append(self.pendingNotificationRequests[indexPath.row])
                } else if indexPath.section ==  1 {
                    items.append(self.deliveredNotifications[indexPath.row])
                }
                
                self.localNotification?.removeNotificationList(items: items)
                self.fetchNotifications()
            })
            deleteAction.backgroundColor = UIColor.red
            
            return [editAction, deleteAction]
        } else {
            return []
        }
    }
}

@available(iOS 10.0, *)
extension NotificationsViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        fetchNotifications()
        completionHandler([.alert, .sound])
    }
}
