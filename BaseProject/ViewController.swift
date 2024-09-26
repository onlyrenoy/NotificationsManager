//
//  ViewController.swift
//  BaseProject
//
//  Created by Renoy Chowdhury on 26/09/24.
//

import Stevia
import UIKit
import UserNotifications

class ViewController: UIViewController {

    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .red
        
        button.setTitle("Tap here to trigger", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        view.subviews(button)
        
        button.centerInContainer()
        button.width(330).height(64)
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    @objc func tap() {
        triggerInAppNotification()
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display the notification as a banner and play a sound
        completionHandler([.banner, .sound])
    }
    
    func triggerInAppNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hello!"
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
