//
//  UserDefaults+MM.swift
//  MedMen
//
//  Created by Jan Zimandl on 20.09.2021.
//

import Foundation

extension UserDefaults {

    var environment: Environment? {
        get {
            let value = self.value(forKey: #function)
            let strValue = value as? String
            let envValue = Environment(rawValue: strValue ?? "??")
            return envValue
        }
        set {
            self.setValue(newValue?.rawValue, forKey: #function)
            self.synchronize()
        }
    }

    var checkedVersion: String? {
        get {
            let value = self.value(forKey: #function)
            let strValue = value as? String
            return strValue
        }
        set {
            self.setValue(newValue, forKey: #function)
            self.synchronize()
        }
    }
}
