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

        FirebaseService.setup()
        AppAnalytics.setup()
        MMRemoteConfig.shared.reload()
        NotificationCenter.default.addObserver(self, selector: #selector(self.remoteConfigDidChange), name: MMRemoteConfig.Notifications.remoteConfigDidChange, object: nil)

        let mainTab = MainTabController.instantiateFromStoryboard()
        self.window?.rootViewController = mainTab
        
        self.window?.makeKeyAndVisible()

        return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.checkVersionAndStatus()
    }

    @objc private func remoteConfigDidChange() {
        self.checkVersionAndStatus()
    }

    private func checkVersionAndStatus() {
        guard let win = self.window else {
            return
        }
        AppStatusManager.shared.checkStatus(in: win)
        AppVersionManager.shared.checkVersion(in: win)
    }

}
