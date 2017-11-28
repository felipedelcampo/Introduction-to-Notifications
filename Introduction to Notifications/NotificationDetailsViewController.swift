//
//  NotificationDetailsViewController.swift
//  Introduction to Notifications
//
//  Created by Pedro Moitinho on 24/11/17.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: UIViewController {
    
    @IBOutlet weak var identifierView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var subtitleView: UIView!
    @IBOutlet weak var bodyView: UIView!
    
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var localNotification: LocalNotificationProtocol?
    var notificationItem: LocalNotificationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            localNotification = LocalNotificationiOS10()
        } else {
            localNotification = LocalNotificationiOS9()
            
            identifierView.removeFromSuperview()
            subtitleView.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let notificationItem = notificationItem {
            identifierTextField.text = notificationItem.identifier
            titleTextField.text = notificationItem.title
            subtitleTextField.text = notificationItem.subtitle
            bodyTextField.text = notificationItem.body
            datePicker.date = notificationItem.triggerDate
        }
    }
    
    @IBAction func didTouchCancelButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
        
        let notificationItem = LocalNotificationItem(identifier: identifierTextField.text ?? "",
                                                     title: titleTextField.text,
                                                     subtitle: subtitleTextField.text,
                                                     body: bodyTextField.text,
                                                     triggerDate: datePicker.date)
        
        localNotification?.scheduleNotification(notificationItem: notificationItem) { error in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Error!", message: error.debugDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func didTouchBackgroundButton(_ sender: Any) {
        
        view.endEditing(true)
    }
}
