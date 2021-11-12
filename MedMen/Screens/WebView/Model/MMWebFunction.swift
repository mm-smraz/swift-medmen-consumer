//
//  MMWebFunction.swift
//  MedMen
//
//  Created by Jan Zimandl on 10.11.2021.
//

import Foundation

enum MMWebFunction {
    case sidebarNavigation(identifier: String)
    case googleHandler(tokenId: String)

    static private let rootObject = "window.nativeApp"

    var jsCode: String {
        var js = MMWebFunction.rootObject + "."
        switch self {
        case let .sidebarNavigation(identifier):
            js += "sidebarNavigation('\(identifier)')"
        case let .googleHandler(tokenId):
            js += "googleHandler('\(tokenId)')"
        }
        js += ";"
        return js
    }
}
