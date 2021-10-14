//
//  UIColor+MM.swift
//  MyMedMen
//
//  Created by Jan Zimandl on 01.03.2021.
//  Copyright © 2021 MedMen. All rights reserved.
//

import UIKit

// swiftlint:disable force_unwrapping

extension UIColor {
    /// Defined colors from Colors.xcassets
    enum MM {   // swiftlint:disable:this type_name

        /// #AA1F16 = 170/31/22 (Primary Red), old: mainRed, mmRed
        static let primaryRed = R.color.mmPrimaryRed()!
        /// #550505 = 85/5/5 (Primary Dark Red), old: MMConstants.Colors.mmDarkPink, mmMaroon, mmBrown
        static let primaryDarkRed = R.color.mmPrimaryDarkRed()!
        /// #222222 = 34/34/34 (Primary Black), old: mmGrayCheckout
        static let primaryBlack = R.color.mmPrimaryBlack()!

        /// Grayscale/Dark Gray #53575A
        static let darkerGray = R.color.mmDarkerGray()!
        /// #7C7C7C = 124/124/124 (Dark Gray), old: mmGrayText, secondaryGray
        static let darkGray = R.color.mmDarkGray()!
        /// #AAAAAA = 170/170/170 (Medium Gray), old: mmGrayDisabled, mmLightCheckout, mmOrderGray
        static let mediumGray = R.color.mmMediumGray()!
        /// #DDDDDD = 221/221/221 (Medium Light Gray) old: mmGray
        static let mediumLightGray = R.color.mmMediumLightGray()!
        /// #F4F4F4 = 244/244/244 (Light Gray), old: mmTan, mmLightGray
        static let lightGray = R.color.mmLightGray()!

        static func checkColors() {
            _ = primaryRed
            _ = primaryDarkRed
            _ = primaryBlack

            _ = darkGray
            _ = mediumGray
            _ = mediumLightGray
            _ = lightGray
        }
    }
}
