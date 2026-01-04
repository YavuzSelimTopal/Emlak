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
        VStack(alignment: .leading, spacing: 10) {
            // 1) Resim
            if let first = property.imageURLs.first, let url = URL(string: first) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack { Rectangle().opacity(0.08); ProgressView() }
                    case .success(let img):
                        img.resizable().scaledToFill()
                    case .failure:
                        ZStack { Rectangle().opacity(0.08); Image(systemName: "photo") }
                    @unknown default:
                        Rectangle().opacity(0.08)
                    }
                }
                .frame(height: 170)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                ZStack { Rectangle().opacity(0.08); Image(systemName: "photo") }
                    .frame(height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            // 2) Metinler
            Text(property.address)
                .font(.headline)
                .lineLimit(2)

            Text("\(property.price) ₺")
                .font(.title3.weight(.semibold))

            if !property.features.isEmpty {
                Text(property.features.prefix(3).joined(separator: " • "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
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
