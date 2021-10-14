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

        #if MMQA
        UIColor.MM.checkColors()
        #endif

        return true
    }

}
