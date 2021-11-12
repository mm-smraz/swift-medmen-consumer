//
//  MMAlertVM.swift
//  MedMen
//
//  Created by Jan Zimandl on 18.10.2021.
//

import UIKit

enum MMAlertIcon {
    case geoLeaf
    case geoLeafSleep
    case geoLeafAlert

    var image: UIImage? {
        switch self {
        case .geoLeaf: return R.image.icon_geoleaf()
        case .geoLeafSleep: return R.image.icon_geoleafSleep()
        case .geoLeafAlert: return R.image.icon_geoleafAlert()
        }
    }
}

struct MMAlertAction {
    enum Style {
        case primary
        case secondary
    }
    let title: String
    let style: Style
    let handler: (() -> Void)?
}

class MMAlertVM {
    let icon: MMAlertIcon?
    let title: String
    let message: String?
    let actions: [MMAlertAction]

    init(icon: MMAlertIcon? = nil, title: String, message: String?, actions: [MMAlertAction] = []) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actions = actions
    }
}
