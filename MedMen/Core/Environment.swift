//
//  Environment.swift
//  MyMedMen
//
//  Created by Jan Zimandl on 20.09.2021.
//  Copyright © 2021 MedMen. All rights reserved.
//

import Foundation

enum Environment: String, CaseIterable {
    case local
    case develop
    case test
    case stage
    case shadow
    case smoke
    case production

    var title: String {
        return rawValue.capitalized
    }
}

extension Environment {

    static var current: Environment {
        #if MMQA
        return UserDefaults.standard.environment ?? .develop
        #else
        return .production
        #endif
    }

    static func setCurrent(_ env: Environment) {
        UserDefaults.standard.environment = env
    }
}
