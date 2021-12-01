//
//  Localizable.swift
//  MedMen
//
//  Created by Jan Zimandl on 24.11.2021.
//

import Foundation

public protocol Localizable {
    func localized() -> String
    func localized(comment: String) -> String
    func localizedFormat(_ arg: CVarArg...) -> String
    func localizedCountFormat(_ count: Int) -> String
}

extension String: Localizable {
    public func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    public func localized(comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
    public func localizedFormat(_ arg: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arg)
    }
    public func localizedCountFormat(_ count: Int) -> String {
        let localizedFormat = self.localized()
        let str = String.localizedStringWithFormat(localizedFormat, count)
        return str
    }
}
