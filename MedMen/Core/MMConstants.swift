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
            return "http://localhost:80"

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

    enum Sites: String {
        case shop = "/shop"
        case orders = "/?userAgent=orderhistory"
        case account = "/?userAgent=profile"
        case bag = "/?userAgent=cart"

        var url: URL {
            let str = MMConstants.baseUrl + self.rawValue
            // swiftlint:disable:next force_unwrapping
            let url = URL(string: str)!
            return url
        }
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
}