//
//  PropertyCardView.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI

struct PropertyCardView: View {
    let property: Property

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Image
            ZStack(alignment: .bottomLeading) {
                propertyImage
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                // Subtle gradient to improve text contrast on image
                LinearGradient(
                    colors: [Color.black.opacity(0.0), Color.black.opacity(0.45)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                HStack(alignment: .bottom) {
                    priceBadge

                    Spacer()

                    if !property.features.isEmpty {
                        featuresBadge
                    }
                }
                .padding(12)
            }

            // MARK: - Text
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(Color.green.opacity(0.85))
                        .padding(.top, 2)

                    Text(property.address)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                }

                if !property.neighborhood.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(property.neighborhood)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if !property.features.isEmpty {
                    FlowTagsView(tags: Array(property.features.prefix(5)))
                }
            }
            .padding(.horizontal, 2)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.green.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 14, x: 0, y: 6)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Subviews & Helpers
private extension PropertyCardView {
    var propertyImage: some View {
        Group {
            if let first = property.imageURLs.first, let url = URL(string: first) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.black.opacity(0.04))
                            ProgressView()
                                .tint(.green)
                        }
                    case .success(let img):
                        img
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.black.opacity(0.04))
                            Image(systemName: "photo")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                    @unknown default:
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.black.opacity(0.04))
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.black.opacity(0.04))
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    var priceBadge: some View {
        Text("\(property.price) ₺")
            .font(.headline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.green.opacity(0.95), Color.green.opacity(0.65)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 4)
    }

    var featuresBadge: some View {
        let count = property.features.count
        return Text("+\(max(0, count - 1))")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.green.opacity(0.55))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
    }
}

private struct FlowTagsView: View {
    let tags: [String]

    var body: some View {
        // Simple horizontal, modern "chip" row.
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color.green.opacity(0.95))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.green.opacity(0.12))
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.green.opacity(0.18), lineWidth: 1)
                        )
                }
            }
            .padding(.vertical, 2)
        }
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var isBlank: Bool { trimmed.isEmpty }
}

private extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let value = self?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else { return nil }
        return value
    }
}

#if DEBUG
extension Property {
    static let previewSample = Property(
        address: "Kadıköy, Caferağa Mah. Moda Cd. No:12",
        neighborhood: "Caferağa",
        street: "Moda Cd.",
        price: 6500000,
        latitude: 40.9833,
        longitude: 29.0271,
        features: ["Yeni boyanmış", "Balkon", "Asansör"],
        imageURLs: ["https://picsum.photos/800/600"],
        searchKeywords: ["kadikoy", "caferaga", "moda", "moda cd"]
    )
}

#Preview {
    PropertyCardView(property: .previewSample)
        .padding()
}
#endif
