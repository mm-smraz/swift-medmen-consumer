//
//  FirebaseService.swift
//  MedMen
//
//  Created by Jan Zimandl on 15.10.2021.
//

import Foundation
import Firebase

enum FirebaseService {
    static func setup() {
        let env = Environment.current
        let filename = env == .production ? "GoogleService-Info" : "GoogleService-Info-develop"
        let filePath = Bundle.main.path(forResource: filename, ofType: "plist")

        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!) else {
            fatalError("Couldn't load config file")
        }
        FirebaseApp.configure(options: fileopts)
    }
}
