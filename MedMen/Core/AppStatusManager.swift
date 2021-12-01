//
//  AppStatusManager.swift
//  MedMen
//
//  Created by Jan Zimandl on 21.10.2021.
//

import UIKit

class AppStatusManager {

    enum Status {
        case running
        case killed
        case maintenance
        case lockedByAge
    }

    static var shared = AppStatusManager()

    var status: Status {
        if AgeGateManager.shared.status == .underAgeLimit {
            return .lockedByAge
        } else if MMRemoteConfig.shared.appIsKilled {
            return .killed
        } else if MMRemoteConfig.shared.appInMaintenance {
            return .maintenance
        } else {
            return .running
        }
    }

    private var overlayVC: UIViewController?

    init() {

    }

    func checkStatus(in window: UIWindow) {

        overlayVC?.view.removeFromSuperview()
        overlayVC = nil

        switch status {
        case .running:
            break
        case .killed:
            let vm = MMAlertVM(icon: .geoLeaf, title: LOC.lbl_WE_WLL_BE_BACK(), message: LOC.msg_ERROR_APP_KILLED(), actions: [
                MMAlertAction(title: LOC.btn_GO_TO_WEB(), style: .primary, handler: { [weak self] in
                    self?.openMedMenCom()
                })
            ])

            let alert = OverlayAlertVC.show(in: window, viewModel: vm)
            self.overlayVC = alert
        case .maintenance:
            let alert = MaintenanceAlertVC.show(in: window)
            self.overlayVC = alert
        case .lockedByAge:
            let vm = AgeGateMV.blockedState
            let vc = AgeGateVC.instantiateFromStoryboard(viewModel: vm)
            window.addSubview(vc.view)
            vc.view.frame = window.bounds
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.overlayVC = vc
        }
    }

    private func openMedMenCom() {
        guard let url = URL(string: MMConstants.baseUrl), UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: -

extension MMRemoteConfig {
    var appIsKilled: Bool {
        return self.appStatus["killed"] as? Bool ?? false
    }

    var appInMaintenance: Bool {
        return self.appStatus["maintenance"] as? Bool ?? false
    }
}
