//
//  NotificationDetailsViewController.swift
//  Introduction to Notifications
//
//  Created by Pedro Moitinho on 24/11/17.
//  Copyright © 2017 Pedro Moitinho. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationDetailsViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func scheduleNotification(at date: Date) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        if let title = titleTextField.text {
            content.title = title
        }
        if let subtitle = subtitleTextField.text {
            content.subtitle = subtitle
        }
        if let body = bodyTextField.text {
            content.body = body
        }
        
        if let image = imageView.image {
            
            do {
                let data = UIImagePNGRepresentation(image)!
                let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathExtension("image.png")
                try? data.write(to: imageURL)
                
                let attachment = try UNNotificationAttachment(identifier: imageURL.lastPathComponent, url: imageURL, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    @IBAction func didTouchCancelButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchSaveButton(_ sender: Any) {
        
        scheduleNotification(at: datePicker.date)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTouchImagePickerButton(_ sender: Any) {
        
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
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
}
