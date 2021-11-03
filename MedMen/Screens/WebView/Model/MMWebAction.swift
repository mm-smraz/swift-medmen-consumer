//
//  MMWebAction.swift
//  MedMen
//
//  Created by Jan Zimandl on 23.09.2021.
//

import Foundation

enum MMWebAction {
    case cartItemsCount(count: Int)

    init?(key: String, value: String) {
        switch key {
        case "appData:cartItems":
            let intVal = Int(value) ?? 0
            self = .cartItemsCount(count: intVal)

        default:
            return nil
        }
    }
}
