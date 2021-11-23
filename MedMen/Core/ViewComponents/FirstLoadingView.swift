//
//  FirstLoadingView.swift
//  MedMen
//
//  Created by Jan Zimandl on 29.10.2021.
//

import UIKit

class FirstLoadingView: UIView {

    @IBOutlet private weak var loaderView: LoaderView!

    var animationDuration: TimeInterval = 0.2
    var minAppearanceInterval: TimeInterval {
        // Hide first after aprox. two rotations
        return 2.5 * loaderView.rotationDuration
    }

    init() {
        super.init(frame: CGRect.zero)
        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }

    private func initialize() {
        // swiftlint:disable:next force_unwrapping
        let rootV = R.nib.firstLoadingView(owner: self)!

        self.addSubview(rootV)
        rootV.frame = self.bounds
        rootV.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.loaderView.startAnimation()
    }

    func show(over vc: UIViewController, animated: Bool = true) {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.alpha = 0
        vc.view.addSubview(self)
        self.frame = vc.view.bounds

        if animated {
            UIView.animate(withDuration: self.animationDuration) {
                self.alpha = 1
            } completion: { (_) in

            }
        } else {
            self.alpha = 1
        }
    }

    func hide(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: self.animationDuration) {
                self.alpha = 0
            } completion: { (_) in
                self.removeFromSuperview()
            }
        } else {
            self.alpha = 0
            self.removeFromSuperview()
        }
    }
}
