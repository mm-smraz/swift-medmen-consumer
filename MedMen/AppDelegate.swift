//
//  AppDelegate.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)

        #if MMQA
        UIColor.MM.checkColors()
        #endif

        let mainTab = MainTabController.instantiateFromStoryboard()
        self.window?.rootViewController = mainTab
        
        self.window?.makeKeyAndVisible()

        return true
    }

}
