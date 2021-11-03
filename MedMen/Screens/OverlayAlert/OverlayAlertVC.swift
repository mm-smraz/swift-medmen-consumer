//
//  OverlayAlertVC.swift
//  MedMen
//
//  Created by Jan Zimandl on 18.10.2021.
//

import UIKit

class OverlayAlertVC: MedMenViewController {

    var viewModel: OverlayAlertVM!

    @IBOutlet private weak var contentStack: UIStackView!

    @IBOutlet private weak var iconImageV: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    @IBOutlet private weak var buttonsStack: UIStackView!

    static func instantiateFromStoryboard(viewModel: OverlayAlertVM) -> OverlayAlertVC {
        // swiftlint:disable:next force_unwrapping
        let alertVC = R.storyboard.overlayAlert.instantiateInitialViewController()!
        alertVC.modalPresentationStyle = .fullScreen
        alertVC.viewModel = viewModel
        return alertVC
    }

    @discardableResult
    static func show(in window: UIWindow, viewModel: OverlayAlertVM) -> OverlayAlertVC {
        let alertVC = OverlayAlertVC.instantiateFromStoryboard(viewModel: viewModel)
        window.addSubview(alertVC.view)
        alertVC.view.frame = window.bounds
        alertVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return alertVC
    }

    @discardableResult
    static func show(in vc: UIViewController, viewModel: OverlayAlertVM) -> OverlayAlertVC {
        let alertVC = Self.instantiateFromStoryboard(viewModel: viewModel)
        vc.present(alertVC, animated: true, completion: nil)
        return alertVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    private func setupUI() {
        iconImageV.image = viewModel.icon?.image
        iconImageV.isHidden = iconImageV.image == nil
        titleLabel.text = viewModel.title
        messageLabel.text = viewModel.message
        messageLabel.isHidden = messageLabel.text == nil

        buttonsStack.subviews.forEach {
            buttonsStack.removeArrangedSubview($0)
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
            buttonsStack.addArrangedSubview(button)
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
        self.dismiss(animated: true, completion: nil)
    }

}
