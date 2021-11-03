//
//  MainTabController.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit

class MainTabController: MedMenViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tabBar: UITabBar!

    private var bagItem: UITabBarItem?

    internal var webViewC: WebViewController!

    static func instantiateFromStoryboard() -> MainTabController {
        // swiftlint:disable:next force_unwrapping
        let vc = R.storyboard.mainTab.instantiateInitialViewController()!
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        webViewC = WebViewController.instantiateFromStoryboard(initURL: MMConstants.Sites.initialUrl, delegate: self)
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
            let item = UITabBarItem(title: $0.title, image: $0.icon, tag: $0.tag)
            if $0 == .bag {
                self.bagItem = item
            }
            return item
        }
        tabBar.items = tabItems
    }

}

// MARK: - UITabBarDelegate

extension MainTabController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        guard let site = MMConstants.Sites(tag: item.tag) else {
            return
        }

        switch site.action {
        case .url(let url):
            webViewC.loadURL(url)
        case .javaScript(let js):
            webViewC.runJavascript(js)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            tabBar.selectedItem = nil
        }
    }
}

// MARK: - WebViewControllerDelegate

extension MainTabController: WebViewControllerDelegate {

    func webViewControllerHandleAction(webViewController: WebViewController, action: MMWebAction) {
        switch action {
        case .cartItemsCount(let count):
            if count > 0 {
                bagItem?.badgeValue = "\(count)"
            } else {
                bagItem?.badgeValue = nil
            }
        }
    }

}
