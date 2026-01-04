//
//  RecommendView.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI

struct RecommendView: View {
    @StateObject private var vm = RecommendViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bütçe (₺)").font(.headline)
                    TextField("Örn: 6000000", text: $vm.budgetText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)

                    Text("Özellik seç (opsiyonel)").font(.headline).padding(.top, 8)

                    // basit seçim listesi
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(vm.featurePool, id: \.self) { f in
                                let selected = vm.selectedFeatures.contains(f)
                                Text(f)
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(selected ? Color.accentColor.opacity(0.18) : Color.black.opacity(0.06))
                                    .clipShape(Capsule())
                                    .onTapGesture {
                                        if selected { vm.selectedFeatures.remove(f) }
                                        else { vm.selectedFeatures.insert(f) }
                                    }
                            }
                        }
                    }

                    Button {
                        Task { await vm.recommend() }
                    } label: {
                        Text("Öner")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)

                    if let err = vm.errorMessage {
                        Text(err).foregroundStyle(.red)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                if vm.isLoading {
                    ProgressView().padding(.top, 10)
                } else if vm.results.isEmpty {
                    Text("Bütçe girip öner al.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
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
            .navigationTitle("Öneri")
        }
    }
}

#Preview {
    RecommendView()
}
