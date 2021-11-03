//
//  MMRemoteConfig.swift
//  MedMen
//
//  Created by Jan Zimandl on 15.10.2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MMRemoteConfig {

    static let shared = MMRemoteConfig()

    enum Notifications {
        static let remoteConfigDidChange = Notification.Name("RemoteConfigDidChange")
    }

    var appVersion: [String: Any] {
        return data["appVersion"] ?? [:]
    }

    var appStatus: [String: Any] {
        return data["appStatus"] ?? [:]
    }

    private let database: Firestore
    private var data = [String: [String: Any]]() {
        didSet {
            NotificationCenter.default.post(name: MMRemoteConfig.Notifications.remoteConfigDidChange, object: data)
        }
    }

    init() {
        database = Firestore.firestore()
        database.settings.isPersistenceEnabled = true
    }

    func reload() {
        auth()
    }

    private func auth() {
        Auth.auth().signInAnonymously { (authResult, error) in
            guard authResult?.user != nil else { return }
            guard let error = error else {
                return self.observeFlags()
            }
            print("Cannot signInAnonymously: \(String(describing: error))")
        }
    }

    private func observeFlags() {
        let collection = "consumer-app"
        database.collection(collection).addSnapshotListener { [weak self] snapshot, error in
            guard let snap = snapshot else { return }
            var newData = [String: [String: Any]]()
            for doc in snap.documents {
                newData[doc.documentID] = doc.data()
            }
            self?.data = newData
        }
    }
}
