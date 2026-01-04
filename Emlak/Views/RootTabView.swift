//
//  RootTabView.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }

            SearchView()
                .tabItem { Label("Ara", systemImage: "magnifyingglass") }

            RecommendView()
                .tabItem { Label("Öner", systemImage: "sparkles") }
        }
    }
}

#Preview {
    RootTabView()
}
