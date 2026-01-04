//
//  EmlakApp.swift
//  Emlak
//
//  Created by MACim on 26.12.2025.
//

import SwiftUI
import FirebaseCore

@main
struct EmlakApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}
