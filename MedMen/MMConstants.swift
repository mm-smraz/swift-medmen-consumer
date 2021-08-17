//
//  MMConstants.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import Foundation

enum MMConstants {

    static let baseUrl = "https://www.medmen.com"

    enum Sites: String {
        case main = "/shop"
        case stores = "/stores"

        var url: URL {
            let str = MMConstants.baseUrl + self.rawValue
            let url = URL(string: str)!
            return url
        }
    }
}
