//
//  MMConstants.swift
//  MedMen
//
//  Created by Jan Zimandl on 04.08.2021.
//

import UIKit

enum MMConstants {

    static var baseUrl: String {
        switch Environment.current {
        case .local:
            return "http://localhost:3000"

        case .develop:
            return "https://dev.medmen.com"

        case .test:
            return "https://test.medmen.com"

        case .stage:
            return "https://stage.medmen.com"

        case .shadow:
            return "https://shadow.medmen.com"

        case .smoke:
            return "https://smoke.medmen.com"

        case .production:
            return "https://www.medmen.com"
        }
    }

    static var appUrlScheme: String {
        #if MMQA
        return "medmenqa"
        #else
        return "medmen"
        #endif
    }

    enum Links {
        static var termsOfService: URL? {
            return URL(string: MMConstants.baseUrl + "/terms-use")
        }
        static var privacyPolicy: URL? {
            return URL(string: MMConstants.baseUrl + "/privacy-policy")
        }
        static var learnMore: URL? {
            return MMRemoteConfig.shared.appStoreURL
        }
    }

    enum GoogleSignIn {
        
        static var clientId: String {
            #if MMQA
            return "189534780367-ov0vshilrr7a3dq9502o0itjbp9t86gt.apps.googleusercontent.com"
            #else
            return "189534780367-6fh9qfhscmg0ec9sq828gfiqovade8pj.apps.googleusercontent.com"
            #endif
        }

        static var redirectUrlScheme: String {
            #if MMQA
            return "com.googleusercontent.apps.189534780367-ov0vshilrr7a3dq9502o0itjbp9t86gt"
            #else
            return "com.googleusercontent.apps.189534780367-6fh9qfhscmg0ec9sq828gfiqovade8pj"
            #endif
        }
    }

    enum Social {

        static var instagramURL: URL {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "https://www.instagram.com/ShopMedMen/")!
        }

        static var facebookURL: URL {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "https://www.facebook.com/MedMenStores")!
        }

        static var twitterURL: URL {
            // swiftlint:disable:next force_unwrapping
            return URL(string: "https://twitter.com/MedMen")!
        }

    }

    static var version: String {
        guard let vNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            assertionFailure("App has no version")
            return ""
        }
        return vNumber
    }

    static var bundle: String {
        guard let bNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            assertionFailure("App has no bundle version")
            return ""
        }
        return bNumber
    }
}
