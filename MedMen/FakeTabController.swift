//
//  FakeTabController.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit

class FakeTabController: UIViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tabBar: UITabBar!

    private var webViewC: WebViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        webViewC = WebViewController.instantiateFromStoryboard(initURL: MMConstants.Sites.main.url)
        webViewC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        webViewC.view.frame = containerView.bounds
        containerView.addSubview(webViewC.view)

        tabBar.backgroundImage = UIImage()
        tabBar.items?.forEach({
            $0.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
            $0.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        })
    }

}

// MARK: - UITabBarDelegate

extension FakeTabController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0: webViewC.loadURL(MMConstants.Sites.main.url)
        case 1: webViewC.loadURL(MMConstants.Sites.stores.url)
        default: break
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            tabBar.selectedItem = nil
        }
    }
}
