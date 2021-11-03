//
//  BGColorButton.swift
//  MyMedMen
//
//  Created by Jan Zimandl on 15.02.2021.
//  Copyright © 2021 MedMen. All rights reserved.
//

import UIKit

class BGColorButton: UIButton {

    override var backgroundColor: UIColor? {
        didSet {
            refreshBackground()
        }
    }

    private var setupCompleted: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCompleted = true
        self.refreshBackground()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupCompleted = true
        self.refreshBackground()
    }

    private func refreshBackground() {
        if self.setupCompleted, let bgColor = self.backgroundColor, bgColor != .clear {
            let img = UIImage.getColoredRectImageWith(color: bgColor.cgColor, andSize: CGSize(width: 1, height: 1))
            self.setBackgroundImage(img, for: .normal)
            self.backgroundColor = .clear
        }
    }
}
