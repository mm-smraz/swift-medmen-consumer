//
//  UIFont+MM.swift
//  MyMedMen
//
//  Created by Jan Zimandl on 12.05.2021.
//  Copyright © 2021 MedMen. All rights reserved.
//

import UIKit

extension UIFont {

    enum FontWeight {
        case normal
        case medium
        case demiBold
        case bold
        case italic
    }

    static func appFont(ofSize size: CGFloat, weight: FontWeight = .normal) -> UIFont {
        let name: String
        switch weight {
        case .normal:
            name = "Avenir Next"
        case .medium:
            name = "AvenirNext-Medium"
        case .demiBold:
            name = "AvenirNext-DemiBold"
        case .bold:
            name = "AvenirNext-Bold"
        case .italic:
            name = "AvenirNext-Italic"
        }
        if let font = UIFont(name: name, size: size) {
            return font
        }
        assertionFailure("Font '\(name)' is missing")

        let backupFont: UIFont
        switch weight {
        case .normal:
            backupFont = UIFont.systemFont(ofSize: size, weight: .regular)
        case .medium:
            backupFont = UIFont.systemFont(ofSize: size, weight: .medium)
        case .demiBold:
            backupFont = UIFont.systemFont(ofSize: size, weight: .semibold)
        case .bold:
            backupFont = UIFont.systemFont(ofSize: size, weight: .bold)
        case .italic:
            backupFont = UIFont.italicSystemFont(ofSize: size)
        }
        return backupFont
    }

}
