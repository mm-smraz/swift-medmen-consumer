//
//  AgeGateManager.swift
//  MedMen
//
//  Created by Jan Zimandl on 23.11.2021.
//

import UIKit

class AgeGateManager {

    enum Status {
        case notSet
        case overAgeLimit
        case underAgeLimit
    }

    static var shared = AgeGateManager()

    var status: Status {
        guard let over21 = UserDefaults.standard.userOver21, UserDefaults.standard.ageLimitSetDate != nil else {
            return .notSet
        }
        if over21 {
            return .overAgeLimit
        } else {
            return .underAgeLimit
        }
    }

    init() {

    }

    func setUserOverLimit(_ userOverLimit: Bool) {
        UserDefaults.standard.userOver21 = userOverLimit
        UserDefaults.standard.ageLimitSetDate = Date()
    }

    func checkStatus(in window: UIWindow) {

        switch self.status {
        case .notSet:
            let vm = AgeGateMV.confirmation
            let vc = AgeGateVC.instantiateFromStoryboard(viewModel: vm)
            let navC = UINavigationController(rootViewController: vc)
            navC.modalPresentationStyle = .fullScreen
            window.rootViewController?.present(navC, animated: true, completion: nil)

        case .underAgeLimit, .overAgeLimit:
            return
        }

    }
}
