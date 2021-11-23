//
//  AppAnalytics.swift
//  MedMen
//
//  Updated by Jan Zimandl on 11/02/2021.
//  Copyright © 2018 MedMen. All rights reserved.
//

import Foundation
import Firebase
import Sentry

enum AnalyticsEvent {
    case signIn
}

// MARK: -

enum AppAnalytics {

    enum Parameter: String {
        case environment

        var key: String {
            return rawValue
        }
    }

    private static let sentryDSN = "https://b3f92fc951b24a5c9ddaf9d194549b4b@o309482.ingest.sentry.io/6047886"

    static func setup() {
        SentrySDK.start { options in
            options.dsn = Self.sentryDSN
            #if MMMQA
            options.environment = "develop"
            options.debug = true
            options.diagnosticLevel = .debug
            #else
            options.environment = "production"
            options.debug = false
            options.diagnosticLevel = .none
            #endif
        }

        updateEnvironment()
    }

    static func updateEnvironment(_ env: Environment = Environment.current) {
        SentrySDK.configureScope { scope in
            scope.setTag(value: env.rawValue, key: Parameter.environment.key)
        }

        Analytics.setUserProperty(env.rawValue, forName: Parameter.environment.key)

        Crashlytics.crashlytics().setCustomValue(env.rawValue, forKey: Parameter.environment.key)
    }

    static func trackEvent(_ event: AnalyticsEvent) {
        SentrySDK.capture(event: event.sentryEvent)
        Analytics.logEvent(event.name, parameters: event.params)
    }

    static func trackError(_ error: Error) {
        SentrySDK.capture(error: error)
        Crashlytics.crashlytics().record(error: error)
    }
}

// MARK: - Tracking Parameters

fileprivate extension AnalyticsEvent {
    
    var name: String {
        switch self {
        case .signIn: return "Sign In"
        }
    }

    var params: [String: Any]? {
        switch self {
        default: return nil
        }
    }
}

// MARK: - Sentry Event

fileprivate extension AnalyticsEvent {
    var sentryEvent: Event {
        let sEvent = Event()
        sEvent.message = SentryMessage(formatted: self.name)
        sEvent.extra = self.params
        sEvent.level = .info
        return sEvent
    }
}
