//
//  SearchView.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.green.opacity(0.8))

                    TextField("Mahalle / Sokak ara…", text: $vm.query)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)

                    Button {
                        Task { await vm.search() }
                    } label: {
                        Text("Ara")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.thinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.green.opacity(0.25), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.top, 12)

                if vm.isLoading {
                    ProgressView()
                        .tint(.green)
                        .padding(.top, 20)
                } else if let err = vm.errorMessage {
                    Text("Hata: \(err)")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .padding(.top, 20)
                } else if vm.results.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: vm.query.isEmpty ? "text.magnifyingglass" : "exclamationmark.magnifyingglass")
                            .font(.title2)
                            .foregroundStyle(Color.green.opacity(0.7))

                        Text(vm.query.isEmpty ? "Arama yapmak için yaz." : "Sonuç bulunamadı.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 28)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.results) { p in
                                NavigationLink {
                                    PropertyMapView(property: p)
                                } label: {
                                    PropertyCardView(property: p)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 6)
                    }
                }

                Spacer()
            }
        }
    }
}

#Preview {
    SearchView()
}
