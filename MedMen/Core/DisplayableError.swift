//
//  DisplayableError.swift
//  MedMen
//
//  Created by Jan Zimandl on 11.11.2021.
//

import UIKit

protocol DisplayableError {
    var title: String? { get }
    var message: String? { get }
}

extension UIAlertController {

    @discardableResult
    static func showError(_ error: DisplayableError, in vc: UIViewController, okAction: (() -> Void)? = nil) -> Bool {
        guard error.title != nil || error.message != nil else {
            return false
        }
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LOC.btn_OK(), style: .cancel, handler: { (_) in
            okAction?()
        }))
        vc.present(alert, animated: true, completion: nil)

        return true
    }
}

extension MMPopupView {

    @discardableResult
    static func showError(_ error: DisplayableError, in vc: UIViewController, okAction: (() -> Void)? = nil) -> Bool {
        guard error.title != nil || error.message != nil else {
            return false
        }
        let vm = MMAlertVM(
            icon: .geoLeafAlert,
            title: error.title ?? "",
            message: error.message,
            actions: [
                MMAlertAction(title: LOC.btn_OK(), style: .primary, handler: {
                    okAction?()
                })
            ]
        )
        let pop = MMPopupView(viewModel: vm)
        pop.show(over: vc)

        return true
    }
}
