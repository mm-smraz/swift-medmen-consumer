//
//  MMRoundButton.swift
//  MyMedMen
//
//  Created by Jan Zimandl on 03.03.2021.
//  Copyright © 2021 MedMen. All rights reserved.
//

import UIKit

class MMRoundButton: BGColorButton {

    enum Style: String {
        case primaryRed
        case secondaryRed
    }

    @IBInspectable
    var styleIdentifier: String?

    var style: Style? {
        get {
            guard let si = styleIdentifier else {
                return nil
            }
            let st = Style(rawValue: si)
            if st == nil {
                assertionFailure("MMRoundButton.Style '\(si)' not defined")
            }
            return st
        }
        set {
            styleIdentifier = newValue?.rawValue
            applyStyle()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Waiting for proper initialization
        self.applyStyle()
        DispatchQueue.main.async {
            self.applyStyle()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Waiting for proper initialization
        self.applyStyle()
        DispatchQueue.main.async {
            self.applyStyle()
        }
    }

    private func applyStyle() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.appFont(ofSize: 14, weight: .demiBold)

        switch style {
        case .primaryRed:
            self.backgroundColor = UIColor.MM.primaryRed
            self.tintColor = UIColor.white
            self.setTitleColor(UIColor.white, for: .normal)
        case .secondaryRed:
            self.backgroundColor = UIColor.white
            self.tintColor = UIColor.MM.primaryRed
            self.setTitleColor(UIColor.MM.primaryRed, for: .normal)
        default:
            break
        }
    }
}
