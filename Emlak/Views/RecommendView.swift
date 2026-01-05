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
                controlsCard

                resultsSection

                Spacer()
            }
        }
        .tint(.green)
    }
}

// MARK: - Subviews
private extension RecommendView {
    var controlsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            budgetSection
            featuresSection
            actionSection
            errorSection
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    var budgetSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bütçe")
                .font(.headline)

            HStack(spacing: 10) {
                Image(systemName: "turkishlirasign.circle.fill")
                    .foregroundStyle(Color.green.opacity(0.85))

                TextField("Örn: 6000000", text: $vm.budgetText)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                Text("₺")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
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
        }
    }

    var featuresSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Özellik seç (opsiyonel)")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(vm.featurePool, id: \.self) { f in
                        FeatureChip(
                            title: f,
                            isSelected: vm.selectedFeatures.contains(f),
                            onTap: { toggleFeature(f) }
                        )
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    var actionSection: some View {
        Button {
            Task { await vm.recommend() }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                Text("Öneri Getir")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }

    @ViewBuilder
    var errorSection: some View {
        if let err = vm.errorMessage {
            Text(err)
                .font(.subheadline)
                .foregroundStyle(.red)
        }
    }

    @ViewBuilder
    var resultsSection: some View {
        if vm.isLoading {
            ProgressView()
                .tint(.green)
                .padding(.top, 20)
        } else if vm.results.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(Color.green.opacity(0.7))

                Text("Bütçe girip öner al.")
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
    }

    func toggleFeature(_ f: String) {
        if vm.selectedFeatures.contains(f) {
            vm.selectedFeatures.remove(f)
        } else {
            vm.selectedFeatures.insert(f)
        }
    }
}

private struct FeatureChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(isSelected ? Color.green.opacity(0.95) : .primary)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.green.opacity(0.16) : Color.black.opacity(0.05))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(isSelected ? Color.green.opacity(0.25) : Color.black.opacity(0.06), lineWidth: 1)
            )
            .contentShape(Capsule(style: .continuous))
            .onTapGesture(perform: onTap)
    }
}

#Preview {
    RecommendView()
}
