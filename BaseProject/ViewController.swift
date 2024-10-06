//
//  ViewController.swift
//  BaseProject
//
//  Created by Renoy Chowdhury on 26/09/24.
//

import Stevia
import UIKit
import UserNotifications

class NotificationCounter {
    static var shared = NotificationCounter()
    
    var count: Int = 0
    
    var notifications: [[String: Any]] = [] {
        didSet {
            count = notifications.count
        }
    }
}

class ViewController: UIViewController {

    let button = UIButton()
    let label = UILabel()
    
    var notificationCounter = NotificationCounter.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let notificat = UserDefaults.standard.array(forKey: "SavedNotifications") as? [[String: Any]] ?? []
        label.text = "\(notificat.count)"
        notificationCounter.count = notificat.count
        notificationCounter.notifications = notificat
        
        
        self.view.backgroundColor = .red
        
        button.setTitle("Tap here to trigger", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
        label.addGestureRecognizer(tap)
        
        view.subviews(button, label)
        
        label.top(200)
        label.centerHorizontally()
        
        button.centerInContainer()
        button.width(330).height(64)
        
        UNUserNotificationCenter.current().delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleDataNotification(_:)), name: .didReceiveData, object: nil)
        
    }
    
    @objc
    func tapLabel() {
        let vc = NotificationsController()

        self.present(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didReceiveData, object: nil)
    }
    
    @objc func tap() {
        triggerInAppNotification()
    }
    
    @objc func handleDataNotification(_ notification: Notification) {
        // Access the data from userInfo
        if let data = notification.userInfo as? [String: Any],
           let message = data["body"] {
            
            print("Received message: \(message)")
            notificationCounter.notifications.append(data)
            label.text = "\(notificationCounter.count)"
            // Update your UI or perform actions based on the message
        }
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        saveNotificationLocally(notification)
        completionHandler([.list, .badge, .banner, .sound])
    }
    
    func saveNotificationLocally(_ notification: UNNotification) {
        let content = notification.request.content
        let title = content.title
        let body = content.body
        let userInfo = content.userInfo
        let receivedDate = Date()
        
        let notificationData: [String: Any] = [
            "title": title,
            "body": body,
            "userInfo": userInfo,
            "receivedDate": receivedDate
        ]
        
        var savedNotifications = UserDefaults.standard.array(forKey: "SavedNotifications") as? [[String: Any]] ?? []
        
        
        savedNotifications.append(notificationData)
        NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: notificationData)
        
        UserDefaults.standard.set(savedNotifications, forKey: "SavedNotifications")
        
        
        
    }
    
    func triggerInAppNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daje!"
        content.body = "This is an in-app notification."
        content.sound = .default

        // Trigger after 1 second
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: "InAppNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled.")
            }
        }
    }
}


extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
}
