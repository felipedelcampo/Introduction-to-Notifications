//
//  NotificationDetailsViewController.swift
//  Introduction to Notifications
//
//  Created by Pedro Moitinho on 24/11/17.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit

class NotificationDetailsViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL: URL?
    
    var notification: LocalNotificationProtocol?
    var notificationItem: LocalNotificationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            notification = LocalNotificationiOS10()
        } else {
            notification = LocalNotificationiOS9()
        }
    }
    
    @IBAction func didTouchCancelButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
        
        let notificationItem = LocalNotificationItem(title: titleTextField.text,
                                                     subtitle: subtitleTextField.text,
                                                     body: bodyTextField.text,
                                                     triggerDate: datePicker.date)
        
        notification?.scheduleNotification(notificationItem: notificationItem) { error in
            DispatchQueue.main.async {
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Error!", message: error.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func didTouchImagePickerButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true)
    }
    
    @IBAction func didTouchBackgroundButton(_ sender: Any) {
        
        view.endEditing(true)
    }
}

extension NotificationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageURL = info[UIImagePickerControllerReferenceURL] as? URL
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated:true, completion: nil)
    }
}
