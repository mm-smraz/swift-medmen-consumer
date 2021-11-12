//
//  AppStatusManager.swift
//  MedMen
//
//  Created by Jan Zimandl on 21.10.2021.
//

import UIKit

class AppStatusManager {

    static var shared = AppStatusManager()

    private var killedAlertVC: UIViewController?
    private var maintenanceAlertVC: UIViewController?

    init() {

    }

    func checkStatus(in window: UIWindow) {

        killedAlertVC?.view.removeFromSuperview()
        killedAlertVC = nil
        maintenanceAlertVC?.view.removeFromSuperview()
        maintenanceAlertVC = nil

        if MMRemoteConfig.shared.appIsKilled {

            let vm = MMAlertVM(icon: .geoLeaf, title: "We’ll Be Back Soon", message: "Sorry, we’re down for maintenance. In the meantime, place an order online through medmen.com.", actions: [
                MMAlertAction(title: "Go to MedMen.com", style: .primary, handler: { [weak self] in
                    self?.openMedMenCom()
                })
            ])

            let alert = OverlayAlertVC.show(in: window, viewModel: vm)
            self.killedAlertVC = alert

        } else if MMRemoteConfig.shared.appInMaintenance {

            let alert = MaintenanceAlertVC.show(in: window)
            self.maintenanceAlertVC = alert

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
