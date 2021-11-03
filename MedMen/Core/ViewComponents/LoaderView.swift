//
//  LoaderView.swift
//  MedMen
//
//  Created by Jan Zimandl on 28.10.2021.
//

import UIKit

class LoaderView: UIView {

    @IBOutlet private weak var containerV: UIView!
    @IBOutlet private weak var rotatingAngleCoverV: UIView!

    var rotationDuration: TimeInterval = 0.8

    private let startAngle = 148 / 180 * CGFloat.pi
    private let rotationAnimationKey = "coverRotation"

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
        let rootV = R.nib.loaderView(owner: self)!

        self.addSubview(rootV)
        rootV.frame = self.bounds
        rootV.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        containerV.layer.cornerRadius = 20
        rotatingAngleCoverV.transform = CGAffineTransform(rotationAngle: startAngle)
    }

    func startAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.duration = rotationDuration
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.repeatCount = .infinity
        animation.values = [self.startAngle, self.startAngle + 2 * CGFloat.pi]
        animation.keyTimes = [0.0, 1.0]
        animation.calculationMode = .cubic
        rotatingAngleCoverV.layer.add(animation, forKey: rotationAnimationKey)
    }

    func stopAnimation() {
        rotatingAngleCoverV.layer.removeAnimation(forKey: rotationAnimationKey)
        rotatingAngleCoverV.transform = CGAffineTransform(rotationAngle: startAngle)
    }
}
