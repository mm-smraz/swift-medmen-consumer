//
//  AgeGateVM.swift
//  MedMen
//
//  Created by Jan Zimandl on 25.11.2021.
//

import UIKit

struct AgeGateMV {
    let title: String
    let subtitle: String

    var overAgeTitle: String?
    var overAgeAction: (() -> Void)?
    var underAgeTitle: String?
    var underAgeAction: (() -> Void)?

    var footerNote: NSAttributedString?
}

extension AgeGateMV {
    static var confirmation: AgeGateMV {
        let ageGateManager = AgeGateManager.shared

        let noteStr = LOC.msg_AGE_GATE_FOOTER()
        let attrNote = NSMutableAttributedString(string: noteStr)
        let tRange = (noteStr as NSString).range(of: LOC.lbl_AGE_GATE_TERMS())
        if let url = MMConstants.Links.termsOfService, tRange.length > 0 {
            attrNote.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue, .attachment: url], range: tRange)
        }
        let pRange = (noteStr as NSString).range(of: LOC.lbl_AGE_GATE_POLICY())
        if let url = MMConstants.Links.privacyPolicy, pRange.length > 0 {
            attrNote.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue, .attachment: url], range: pRange)
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        return AgeGateMV(
            title: LOC.lbl_AGE_GATE_TITLE(),
            subtitle: LOC.lbl_AGE_GATE_SUBTITLE(),
            overAgeTitle: LOC.btn_AGE_GATE_OVER(),
            overAgeAction: {
                ageGateManager.setUserOverLimit(true)
                appDelegate?.checkVersionAndStatus()
            },
            underAgeTitle: LOC.btn_AGE_GATE_UNDER(),
            underAgeAction: {
                ageGateManager.setUserOverLimit(false)
                appDelegate?.checkVersionAndStatus()
            },
            footerNote: attrNote
        )
    }

    static var blockedState: AgeGateMV {
        return AgeGateMV(
            title: LOC.lbl_AGE_LOCKED_TITLE(),
            subtitle: LOC.lbl_AGE_LOCKED_SUBTITLE()
        )
    }
}
