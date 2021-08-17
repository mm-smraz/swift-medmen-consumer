//
//  MainTabBarController.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    private var mainVC: WebViewController!
    private var storesVC: WebViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarItem.appearance(whenContainedInInstancesOf: [MainTabBarController.self])
        appearance.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        appearance.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

        var vcs = [UIViewController]()

        mainVC = WebViewController.instantiateFromStoryboard(initURL: MMConstants.Sites.main.url, delegate: self)
        let navC0 = UINavigationController(rootViewController: mainVC)
        navC0.tabBarItem = UITabBarItem(title: "MedMen", image: UIImage(named: "medmenPotLeaf"), tag: 0)
        vcs.append(navC0)

        storesVC = WebViewController.instantiateFromStoryboard(initURL: MMConstants.Sites.stores.url, delegate: self)
        let navC1 = UINavigationController(rootViewController: storesVC)
        navC1.tabBarItem = UITabBarItem(title: "Stores", image: UIImage(named: "icon_storePickup"), tag: 1)
        vcs.append(navC1)

        self.setViewControllers(vcs, animated: false)
    }
}

// MARK: - UITabBarControllerDelegates

extension MainTabBarController: UITabBarControllerDelegate {

}

// MARK: - WebViewControllerDelegate

extension MainTabBarController: WebViewControllerDelegate {

    func webViewControllerHandleAction(webViewController: WebViewController, action: String) {

    }

}
