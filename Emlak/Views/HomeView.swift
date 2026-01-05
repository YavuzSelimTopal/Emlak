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
            ZStack {
                // Subtle grouped background for a modern, clean look
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                Group {
                    if vm.isLoading {
                        ProgressView()
                            .tint(.green)
                            .scaleEffect(1.1)
                    } else if let err = vm.errorMessage {
                        errorState(err)
                    } else if vm.properties.isEmpty {
                        emptyState
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
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
                            .padding(.bottom, 16)
                        }
                        .refreshable {
                            await vm.load()
                        }
                    }
                }
            }
            .navigationTitle("Emlak")
            .navigationBarTitleDisplayMode(.large)
        }
        .tint(.green)
        .task {
            await vm.load()
        }
    }
}

// MARK: - States
private extension HomeView {
    func errorState(_ err: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title)
                .foregroundStyle(Color.green.opacity(0.75))

            Text("Bir sorun oluştu")
                .font(.headline)

            Text("Hata: \(err)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                Task { await vm.load() }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.clockwise")
                    Text("Tekrar Dene")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.green.opacity(0.25), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "house.and.flag.fill")
                .font(.title)
                .foregroundStyle(Color.green.opacity(0.75))

            Text("Henüz ilan yok")
                .font(.headline)

            Text("Yeni ilanlar eklendikçe burada görünecek.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeView()
}
