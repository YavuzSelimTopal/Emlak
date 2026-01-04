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
                    TextField("Mahalle / Sokak ara…", text: $vm.query)
                        .textFieldStyle(.roundedBorder)

                    Button("Ara") {
                        Task { await vm.search() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                if vm.isLoading {
                    ProgressView().padding(.top, 16)
                } else if let err = vm.errorMessage {
                    Text("Hata: \(err)").foregroundStyle(.red).padding(.top, 16)
                } else if vm.results.isEmpty {
                    Text(vm.query.isEmpty ? "Arama yapmak için yaz." : "Sonuç bulunamadı.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 24)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
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
            .navigationTitle("Arama")
        }
    }
}

#Preview {
    SearchView()
}
