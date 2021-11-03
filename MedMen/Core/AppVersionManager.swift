//
//  AppVersionManager.swift
//  MedMen
//
//  Created by Jan Zimandl on 19.10.2021.
//

import UIKit

class AppVersionManager {

    static var shared = AppVersionManager()

    private var reqVersionAlert: OverlayAlertVC?
    private weak var currentAlert: UIAlertController?

    init() {

    }

    func checkVersion(in window: UIWindow) {
        let currentVersion = MMConstants.version

        var newCurVer: String?
        var reqVer: String?

        if let cVer = MMRemoteConfig.shared.currentVersion {
            if currentVersion.versionCompare(cVer) == .orderedAscending && UserDefaults.standard.checkedVersion != cVer {
                newCurVer = cVer
            }
        }

        if let rVer = MMRemoteConfig.shared.requiredVersion {
            if currentVersion.versionCompare(rVer) == .orderedAscending {
                reqVer = rVer
            }
        }

        if let rVer = reqVer {

            currentAlert?.dismiss(animated: false, completion: nil)
            currentAlert = nil

            print("Required version: \(rVer)")
            // Hide last reqVersionAlert if presented
            reqVersionAlert?.view.removeFromSuperview()

            let vm = OverlayAlertVM(icon: .geoLeaf, title: "Please Update MedMen", message: "This version of the app is no longer supported. Please install the latest version.", actions: [
                OverlayAlertAction(title: "Update", style: .primary, handler: { [weak self] in
                    self?.openAppStore()
                }),
                OverlayAlertAction(title: "Learn More", style: .secondary, handler: { [weak self] in
                    self?.showLearnMore()
                })
            ])

            let alert = OverlayAlertVC.show(in: window, viewModel: vm)
            self.reqVersionAlert = alert

        } else if let cVer = newCurVer {

            reqVersionAlert?.view.removeFromSuperview()
            reqVersionAlert = nil

            print("New version: \(cVer)")
            // Don't show new alert when the old one is there
            guard self.currentAlert == nil else {
                return
            }

            let alert = UIAlertController(title: "Update Available", message: "For the best shopping experience, please update now.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { [weak self] (_) in
                self?.currentAlert = nil
                UserDefaults.standard.checkedVersion = cVer
            }))
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { [weak self] (_) in
                self?.currentAlert = nil
                UserDefaults.standard.checkedVersion = cVer
                self?.openAppStore()
            }))
            self.currentAlert = alert
            window.rootViewController?.present(alert, animated: true, completion: nil)

        } else {
            // Hide last reqVersionAlert if presented
            reqVersionAlert?.view.removeFromSuperview()
            reqVersionAlert = nil

            // Hide last currentAlert if presented
            currentAlert?.dismiss(animated: false, completion: nil)
            currentAlert = nil
        }
    }

    private func openAppStore() {
        guard let url = MMRemoteConfig.shared.appStoreURL, UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func showLearnMore() {
        self.openAppStore()
    }
}

// MARK: -

extension MMRemoteConfig {
    var currentVersion: String? {
        return self.appVersion["currentVersion"] as? String
    }

    var requiredVersion: String? {
        return self.appVersion["requiredVersion"] as? String
    }

    var appStoreURL: URL? {
        let urlStr = self.appVersion["appStoreUrl"] as? String ?? ""
        return URL(string: urlStr)
    }
}

// MARK: -

extension String {
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        let versionDelimiter = "."

        var versionComponents = self.components(separatedBy: versionDelimiter)
        var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)

        let zeroDiff = versionComponents.count - otherVersionComponents.count

        if zeroDiff == 0 {
            // Same format, compare normally
            return self.compare(otherVersion, options: .numeric)
        } else {
            let zeros = Array(repeating: "0", count: abs(zeroDiff))
            if zeroDiff > 0 {
                otherVersionComponents.append(contentsOf: zeros)
            } else {
                versionComponents.append(contentsOf: zeros)
            }
            let newOtherVersion = otherVersionComponents.joined(separator: versionDelimiter)
            let newVersion = versionComponents.joined(separator: versionDelimiter)
            return newVersion.compare(newOtherVersion, options: .numeric)
        }
    }
}
