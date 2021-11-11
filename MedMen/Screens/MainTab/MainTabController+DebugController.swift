//
//  MainTabController+DebugController.swift
//  MedMen
//
//  Created by Jan Zimandl on 21.09.2021.
//

import UIKit

extension MainTabController: DebugController {

    var debugActions: [UIAlertAction] {
        return [
            UIAlertAction(title: "Change Environment", style: .default) { (_) in
                self.changeEnvironment()
            },
            UIAlertAction(title: "Load Test Page", style: .default, handler: { (_) in
                // swiftlint:disable:next force_unwrapping
                let testUrl = URL(string: "http://test.zimandl.cz/app-communication.php")!
                self.webViewC.loadURL(testUrl)
            })
        ]
    }

    private func changeEnvironment() {
        let sheet = UIAlertController(title: "Change Environment", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        let currentEnv = Environment.current
        for env in Environment.allCases {

            var title = env.title
            if env == currentEnv {
                title = "✓ " + title
            }
            sheet.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                Environment.setCurrent(env)
                self?.webViewC.initURL = MMConstants.Sites.initialUrl
                self?.webViewC.reloadInitURL()
                self?.selectTab(.shop)
            }))

        }

        self.present(sheet, animated: true, completion: nil)
    }
}
