//
//  MMConstants.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit

enum MMConstants {

    static var baseUrl: String {
        switch Environment.current {
        case .local:
            return "http://localhost:3000"

        case .develop:
            return "https://dev.medmen.com"

        case .test:
            return "https://test.medmen.com"

        case .stage:
            return "https://stage.medmen.com"

        case .shadow:
            return "https://shadow.medmen.com"

        case .smoke:
            return "https://smoke.medmen.com"

        case .production:
            return "https://www.medmen.com"
        }
    }

    enum Social {

        static var instagramURL: URL {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "https://www.instagram.com/ShopMedMen/")!
        }

        static var facebookURL: URL {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "https://www.facebook.com/MedMenStores")!
        }

        static var twitterURL: URL {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "https://twitter.com/MedMen")!
        }

    }

    enum Sites {

        enum Action {
            case url(url: URL)
            case javaScript(js: String)
        }

        case shop // = "/shop"
        case orders // = "/?userAgent=orderhistory"
        case account // = "/?userAgent=profile"
        case bag // = "/?userAgent=cart"

        static var initialUrl: URL {
            // swiftlint:disable:next force_unwrapping
            return URL(string: MMConstants.baseUrl + "/shop")!
        }

        var action: Action {
            switch self {
            case .shop:
                // swiftlint:disable:next force_unwrapping
                return .url(url: URL(string: MMConstants.baseUrl + "/shop")!)
            case .orders:
                return .javaScript(js: "window.nativeApp.sidebarNavigation('orderhistory');")
            case .account:
                return .javaScript(js: "window.nativeApp.sidebarNavigation('profile');")
            case .bag:
                return .javaScript(js: "window.nativeApp.sidebarNavigation('cart');")
            }
        }
    }

    static var version: String {
        guard let vNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            assertionFailure("App has no version")
            return ""
        }
        return vNumber
    }

    static var bundle: String {
        guard let bNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            assertionFailure("App has no bundle version")
            return ""
        }
        return bNumber
    }
}

// MARK: - MMConstants.Sites UI Extension

extension MMConstants.Sites {

    init?(tag: Int) {
        switch tag {
        case Self.shop.tag: self = .shop
        case Self.orders.tag: self = .orders
        case Self.account.tag: self = .account
        case Self.bag.tag: self = .bag
        default: return nil
        }
    }

    var tag: Int {
        switch self {
        case .shop: return 1
        case .orders: return 2
        case .account: return 3
        case .bag: return 4
        }
    }

    var title: String {
        switch self {
        case .shop: return "Shop"
        case .orders: return "Orders"
        case .account: return "Account"
        case .bag: return "Bag"
        }
    }

    var icon: UIImage {
        // swiftlint:disable force_unwrapping
        switch self {
        case .shop: return R.image.icon_tabStore()!
        case .orders: return R.image.icon_tabTicket()!
        case .account: return R.image.icon_tabAccount()!
        case .bag: return R.image.icon_tabBag()!
        }
        // swiftlint:enable force_unwrapping
    }

    var highlightedIcon: UIImage {
        // swiftlint:disable force_unwrapping
        switch self {
        case .shop: return R.image.icon_tabStore_h()!
        case .orders: return R.image.icon_tabTicket_h()!
        case .account: return R.image.icon_tabAccount_h()!
        case .bag: return R.image.icon_tabBag_h()!
        }
        // swiftlint:enable force_unwrapping
    }
}
