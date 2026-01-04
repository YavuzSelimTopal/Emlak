//
//  HomeView.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView()
                } else if let err = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text("Hata: \(err)")
                        Button("Tekrar Dene") { Task { await vm.load() } }
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(vm.properties) { p in
                                NavigationLink {
                                    PropertyMapView(property: p)
                                } label: {
                                    PropertyCardView(property: p)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    }
                }
            }
            .navigationTitle("Emlak")
        }
        .task {
            await vm.load()
        }
    }
}

#Preview {
    HomeView()
}
