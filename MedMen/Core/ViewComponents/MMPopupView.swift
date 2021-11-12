//
//  MMPopupView.swift
//  MedMen
//
//  Created by Jan Zimandl on 05.11.2021.
//

import UIKit

class MMPopupView: UIView {

    var animationDuration: TimeInterval = 0.2

    @IBOutlet private weak var backgroundV: UIView!
    @IBOutlet private weak var containerV: UIView!
    @IBOutlet private weak var iconImageV: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    @IBOutlet private weak var actionsStack: UIStackView!

    private let viewModel: MMAlertVM

    init(viewModel: MMAlertVM) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        self.initialize()
    }

    override init(frame: CGRect) {
        fatalError("Not implemented. Use init(viewModel:)")
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented. Use init(viewModel:)")
    }

    private func initialize() {
        // swiftlint:disable:next force_unwrapping
        let rootV = R.nib.mmPopupView(owner: self)!

        self.addSubview(rootV)
        rootV.frame = self.bounds
        rootV.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        containerV.layer.cornerRadius = 20

        iconImageV.image = viewModel.icon?.image
        iconImageV.isHidden = iconImageV.image == nil
        titleLabel.text = viewModel.title
        titleLabel.isHidden = titleLabel.text == nil
        messageLabel.text = viewModel.message
        messageLabel.isHidden = messageLabel.text == nil

        actionsStack.subviews.forEach {
            actionsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for (index, action) in viewModel.actions.enumerated() {
            let button = MMRoundButton(frame: .zero)
            switch action.style {
            case .primary: button.style = .primaryRed
            case .secondary: button.style = .secondaryRed
            }
            button.setTitle(action.title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.tag = index
            button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
            actionsStack.addArrangedSubview(button)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        let actionIndex = sender.tag
        guard actionIndex >= 0 && actionIndex < viewModel.actions.count else {
            assertionFailure("Wrong tag for action button - out of actions range")
            return
        }
        let action = viewModel.actions[sender.tag]
        action.handler?()
        self.hide()
    }

    func show(over vc: UIViewController, animated: Bool = true) {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.alpha = 0
        vc.view.addSubview(self)
        self.frame = vc.view.bounds

        if animated {
            UIView.animate(withDuration: self.animationDuration) {
                self.alpha = 1
            } completion: { (finished) in

            }
        } else {
            self.alpha = 1
        }
    }

    func hide(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: self.animationDuration) {
                self.alpha = 0
            } completion: { (finished) in
                self.removeFromSuperview()
            }
        } else {
            self.alpha = 0
            self.removeFromSuperview()
        }
    }
}
