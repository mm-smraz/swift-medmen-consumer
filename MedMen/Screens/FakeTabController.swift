//
//  FakeTabController.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit

class FakeTabController: MedMenViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tabBar: UITabBar!

    internal var webViewC: WebViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        webViewC = WebViewController.instantiateFromStoryboard(initURL: MMConstants.Sites.shop.url)
        webViewC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        webViewC.view.frame = containerView.bounds
        containerView.addSubview(webViewC.view)

        tabBar.backgroundImage = UIImage()
        tabBar.tintColor = UIColor.MM.primaryRed
        tabBar.unselectedItemTintColor = UIColor.MM.darkerGray
        
        prepareTabBarItems()

    }

    private func prepareTabBarItems() {
        let tabSites: [MMConstants.Sites] = [.shop, .orders, .account, .bag]
        let tabItems: [UITabBarItem] = tabSites.map {
            UITabBarItem(title: $0.title, image: $0.icon, tag: $0.tag)
        }
        tabBar.items = tabItems
    }

}

// MARK: - UITabBarDelegate

extension FakeTabController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        guard let site = MMConstants.Sites(tag: item.tag) else {
            return
        }

        webViewC.loadURL(site.url)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            tabBar.selectedItem = nil
        }
    }
}
