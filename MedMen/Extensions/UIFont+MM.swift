//
//  UIFont+MM.swift
//  MyMedMen
//
//  Created by Jan Zimandl on 12.05.2021.
//  Copyright © 2021 MedMen. All rights reserved.
//

import UIKit

extension UIFont {

    // swiftlint:disable:next type_name
    enum MM {
        static let title = UIFont.preferredFont(forTextStyle: .title1)
        static let text = UIFont.preferredFont(forTextStyle: .body)
        static let button = UIFont.preferredFont(forTextStyle: .headline)
    }

    enum FontWeight {
        case normal
        case medium
        case demiBold
        case bold
        case italic
    }

    static func appFont(ofSize size: CGFloat, weight: FontWeight = .normal) -> UIFont {
        let backupFont: UIFont
        switch weight {
        case .normal:
            backupFont = UIFont.systemFont(ofSize: size, weight: .regular)
        case .medium:
            backupFont = UIFont.systemFont(ofSize: size, weight: .regular)
        case .demiBold:
            backupFont = UIFont.systemFont(ofSize: size, weight: .medium)
        case .bold:
            backupFont = UIFont.systemFont(ofSize: size, weight: .semibold)
        case .italic:
            backupFont = UIFont.italicSystemFont(ofSize: size)
        }
        return backupFont
    }

}
