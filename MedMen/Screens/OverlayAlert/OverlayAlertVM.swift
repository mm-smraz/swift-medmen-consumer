//
//  OverlayAlertVM.swift
//  MedMen
//
//  Created by Jan Zimandl on 18.10.2021.
//

import UIKit

enum OverlayAlertIcon {
    case geoLeaf
    case geoLeafSleep

    var image: UIImage? {
        switch self {
        case .geoLeaf: return R.image.icon_geoleaf()
        case .geoLeafSleep: return R.image.icon_geoleafSleep()
        }
    }
}

struct OverlayAlertAction {
    enum Style {
        case primary
        case secondary
    }
    let title: String
    let style: Style
    let handler: (() -> Void)?
}

class OverlayAlertVM {
    let icon: OverlayAlertIcon?
    let title: String
    let message: String?
    let actions: [OverlayAlertAction]

    init(icon: OverlayAlertIcon? = nil, title: String, message: String?, actions: [OverlayAlertAction] = []) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actions = actions
    }
}
