//
//  AppDelegate.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 02.10.14.
//  Copyright (c) 2014 iOSLab. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import VK_ios_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Nested Types
    
    fileprivate enum Constants {
        
        // MARK: - Nested Properties
        
        static let launchScreenStoryboardName = "LaunchScreen"
        static let mainStoryboardName = "Main"
        static let launchScreenIdentifier = "LaunchScreenIdentifier"
        static let navigationControllerIdentifier = "NavigationController"

        static let rinksStoryboardName = "Rinks"
        static let welcomeStoryboardName = "Welcome"
        
        static let launchScreenDuration: Double = 5
    }
    
    // MARK: - Instance Properties

    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        if UserDefaultsManager.shared.getToken() != nil {
            window?.rootViewController = UIStoryboard.init(name: Constants.rinksStoryboardName, bundle: nil).instantiateInitialViewController()
        } else {
            window?.rootViewController = UIStoryboard.init(name: Constants.welcomeStoryboardName, bundle: nil).instantiateInitialViewController()
        }

        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        return true
    }
    
    @objc private func dismissLaunchScreenViewController() {
        let newTripViewController = UIStoryboard.init(name: Constants.mainStoryboardName, bundle: nil)
        let rootViewController = newTripViewController.instantiateViewController(withIdentifier: Constants.navigationControllerIdentifier)
        
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
