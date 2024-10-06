//
//  AppDelegate.swift
//  BaseProject
//
//  Created by Renoy Chowdhury on 26/09/24.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let home = UINavigationController(rootViewController: ViewController())
        home.navigationBar.tintColor = .white
        self.window?.rootViewController = home
        self.window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error here.
                print("Authorization error: \(error.localizedDescription)")
            } else if granted {
                // Permission granted.
                print("Notification permission granted.")
            } else {
                // Permission denied.
                print("Notification permission denied.")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Foreground notification handling
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Save notification locally
            saveNotificationLocally(notification)
            
            // Show the notification as a banner and play a sound
            completionHandler([.list, .badge, .banner, .sound])
        }
        
        // Background notification handling
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            // Save notification locally
            saveNotificationLocally(response.notification)
            
            // Handle the action
            // ...
            
            completionHandler()
        }
        
        // Save notification content
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
            UserDefaults.standard.set(savedNotifications, forKey: "SavedNotifications")
        }
    
}
