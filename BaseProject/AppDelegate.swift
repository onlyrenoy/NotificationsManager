//
//  AppDelegate.swift
//  BaseProject
//
//  Created by Renoy Chowdhury on 26/09/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let home = UINavigationController(rootViewController: ViewController())
        home.navigationBar.tintColor = .white
        self.window?.rootViewController = home
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
