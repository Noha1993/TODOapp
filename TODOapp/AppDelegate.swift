//
//  AppDelegate.swift
//  TODOapp
//
//  Created by KAZUMA NOHA on 2019/12/12.
//  Copyright © 2019 KAZUMA NOHA. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle
}

