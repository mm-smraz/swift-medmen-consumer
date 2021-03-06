//
//  AppInfo.swift
//  MedMen
//
//  Created by Jan Zimandl on 02.09.2021.
//

import Foundation

// swiftlint:disable force_unwrapping
// swiftlint:disable force_cast

enum AppInfo {

    private static var infoDict: [String: Any] {
        return Bundle.main.infoDictionary!
    }

    static var versionNumber: String {
        return infoDict["CFBundleShortVersionString"] as! String
    }

    static var buildNumber: String {
        return infoDict["CFBundleVersion"] as! String
    }
}
