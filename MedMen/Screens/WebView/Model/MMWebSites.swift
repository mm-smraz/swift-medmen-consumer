//
//  MMWebSites.swift
//  MedMen
//
//  Created by Jan Zimandl on 10.11.2021.
//

import UIKit

enum MMWebSites {

    enum Action {
        case url(url: URL)
        case javaScript(js: String)
        case webFunction(wf: MMWebFunction)
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
            return .webFunction(wf: .sidebarNavigation(identifier: "orderhistory"))
        case .account:
            return .webFunction(wf: .sidebarNavigation(identifier: "profile"))
        case .bag:
            return .webFunction(wf: .sidebarNavigation(identifier: "cart"))
        }
    }
}

// MARK: - MMWebSites UI Extension

extension MMWebSites {

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
        case .shop: return LOC.tab_SHOP()
        case .orders: return LOC.tab_ORDERS()
        case .account: return LOC.tab_ACCOUNT()
        case .bag: return LOC.tab_BAG()
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
