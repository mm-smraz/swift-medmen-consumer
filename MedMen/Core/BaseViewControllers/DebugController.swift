//
//  DebugController.swift
//  MMMQA
//
//  Created by Jeff Trespalacios on 3/24/20.
//  Copyright © 2020 MedMen. All rights reserved.
//

import UIKit

protocol DebugController where Self: UIViewController {
    var debugActions: [UIAlertAction] { get }
}

extension UIViewController {
    @objc func presentDebugAlert() {
        guard let debug = self as? DebugController else {
            return
        }
        let actions = debug.debugActions
        guard !actions.isEmpty else {
            return
        }

        let alert = UIAlertController(
            title: "DEBUG MENU",
            message: nil,
            preferredStyle: .actionSheet
        )
        actions.forEach { alert.addAction($0) }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension DebugController {
    func configureDebugHandler() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(presentDebugAlert))
        gesture.numberOfTapsRequired = 2
        gesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gesture)
    }

    /// Present an alert with cancel action to configuration
    func presentAlertWith(
        title: String,
        message: String,
        textConfigurators: [(UITextField) -> Void] = [],
        actions: [UIAlertAction] = []
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        textConfigurators.forEach { alert.addTextField(configurationHandler: $0) }
        actions.forEach { alert.addAction($0) }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
