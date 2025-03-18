//
//  AppDelegate.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 24/08/2023.
//

import UIKit
import IQKeyboardManagerSwift
import Glassfy
import FacebookCore
import FirebaseCore
import ArkanaKeys

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        // Firebase
        FirebaseApp.configure()
        
        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // Glassfy
        Glassfy.initialize(apiKey: ArkanaKeys.Keys.Global().glassfyApiKey, watcherMode: false)
        
        // Analytics
        if !UserDefaultsManager.shared.getBool(by: .firstLaunchPerformed) {
            AnalyticsManager.shared.track(event: .firstLaunch)
            UserDefaultsManager.shared.save(value: true, forKey: .firstLaunchPerformed)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

