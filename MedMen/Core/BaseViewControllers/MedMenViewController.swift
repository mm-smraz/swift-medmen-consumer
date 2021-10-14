//
//  MedMenViewController.swift
//  MMMQA
//
//  Created by Jeff Trespalacios on 5/20/20.
//  Copyright © 2020 MedMen. All rights reserved.
//

import UIKit

public class MedMenViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        #if MMQA
        if let d = self as? DebugController {
            d.configureDebugHandler()
        }
        #endif
    }
}
