//
//  MainTabController.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit

class MainTabController: MedMenViewController {

    var deselectTabAfterDelay: Bool = false
    let tabSites: [MMWebSites] = [.shop, .orders, .account, .bag]

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tabBar: UITabBar!
    @IBOutlet private weak var headerV: UIView!
    @IBOutlet private weak var footerV: UIView!

    private var bagItem: UITabBarItem?

    internal var webViewC: WebViewController!

    private var loadingScreen: FirstLoadingView?
    private var loadingScreenAppearance: Date?
    private var loadingScreenHideTimer: Timer?

    static func instantiateFromStoryboard() -> MainTabController {
        // swiftlint:disable:next force_unwrapping
        let vc = R.storyboard.mainTab.instantiateInitialViewController()!
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        prepareTabBarItems()
        showFirstLoader()

        selectTab(.shop)
    }

    @discardableResult
    func selectTab(_ site: MMWebSites) -> Bool {
        guard let index = tabSites.firstIndex(of: site) else {
            return false
        }
        return selectTab(index: index)
    }

    @discardableResult
    func selectTab(index: Int) -> Bool {
        let itemsCount = tabBar.items?.count ?? 0
        guard index < itemsCount && index >= 0 else {
            return false
        }
        let item = tabBar.items?[index]
        tabBar.selectedItem = item

        if deselectTabAfterDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tabBar.selectedItem = nil
            }
        }

        return true
    }

    private func setupUI() {
        webViewC = WebViewController.instantiateFromStoryboard(initURL: MMWebSites.initialUrl, delegate: self)
        webViewC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        webViewC.view.frame = containerView.bounds
        containerView.addSubview(webViewC.view)

        tabBar.backgroundImage = UIImage()
        tabBar.tintColor = UIColor.MM.primaryBlack
        tabBar.unselectedItemTintColor = UIColor.MM.darkerGray
        tabBar.backgroundColor = UIColor.white
        tabBar.layer.shadowColor = UIColor.MM.mediumLightGray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = 0

        footerV.backgroundColor = tabBar.backgroundColor
    }

    private func prepareTabBarItems() {
        let tabItems: [UITabBarItem] = tabSites.map {
            let item = UITabBarItem(title: $0.title, image: $0.icon, tag: $0.tag)
            item.selectedImage = $0.highlightedIcon
            item.badgeColor = UIColor.MM.primaryRed
            if $0 == .bag {
                self.bagItem = item
            }
            return item
        }
        tabBar.items = tabItems
    }

    private func showFirstLoader() {
        loadingScreen = FirstLoadingView()
        loadingScreen?.show(over: self, animated: false)
        loadingScreenAppearance = Date()
    }

    private func hideFirstLoaderAfterDelay() {
        guard let ls = loadingScreen, loadingScreenHideTimer == nil else {
            return
        }

        var delay: TimeInterval = 0
        if let date = loadingScreenAppearance {
            let timeIntervalSinceAppearance = Date().timeIntervalSince(date)
            let hideDelay = ls.minAppearanceInterval - timeIntervalSinceAppearance
            if hideDelay > 0 {
                delay = hideDelay
            }
        }

        loadingScreenHideTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] (_) in
            ls.hide()
            self?.loadingScreen = nil
            self?.loadingScreenHideTimer = nil
        })
    }

}

// MARK: - UITabBarDelegate

extension MainTabController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        guard let site = MMWebSites(tag: item.tag) else {
            return
        }

        webViewC.runWebFunction(site.webFunction) { [weak self] result in
            switch result {
            case .success:
                print("JS tab switch function succeeded")

            case .failure:
                // Load url if the JS function failed
                self?.webViewC.loadURL(site.url)
            }
        }

        if deselectTabAfterDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                tabBar.selectedItem = nil
            }
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

    func webViewControllerLoadingStateChanged(webViewController: WebViewController, isLoading: Bool) {
        if !isLoading {
            hideFirstLoaderAfterDelay()
        }
    }
}
