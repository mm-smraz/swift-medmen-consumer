//
//  MaintenanceAlertVC.swift
//  MedMen
//
//  Created by Jan Zimandl on 21.10.2021.
//

import UIKit

class MaintenanceAlertVC: MedMenViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    static func instantiateFromStoryboard() -> MaintenanceAlertVC {
        // swiftlint:disable:next force_unwrapping
        let alertVC = R.storyboard.overlayAlert.maintenanceAlert()!
        alertVC.modalPresentationStyle = .fullScreen
        return alertVC
    }

    @discardableResult
    static func show(in window: UIWindow) -> MaintenanceAlertVC {
        let alertVC = MaintenanceAlertVC.instantiateFromStoryboard()
        window.addSubview(alertVC.view)
        alertVC.view.frame = window.bounds
        alertVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return alertVC
    }

    // MARK: - Actions

    @IBAction private func socialTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            openURL(MMConstants.Social.instagramURL)
        case 2:
            openURL(MMConstants.Social.facebookURL)
        default:
            return
        }
    }

    private func openURL(_ url : URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
