//
//  PropertyMapView.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI
import MapKit

struct PropertyMapView: View {
    let property: Property

    @State private var position: MapCameraPosition

    init(property: Property) {
        self.property = property
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: property.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: - Map
            Map(position: $position) {
                Annotation(property.address, coordinate: property.coordinate) {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 34, height: 34)

                        Image(systemName: "house.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .bold))
                    }
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                }
            }
            .ignoresSafeArea(edges: .top)

            // MARK: - Bottom Info Card
            infoCard
        }
        .navigationTitle("Harita")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Info Card
private extension PropertyMapView {
    var infoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(property.address)
                        .font(.headline)
                        .lineLimit(2)

                    Text("\(property.price) ₺")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color.green)
                }

                Spacer()

                Image(systemName: "map.fill")
                    .foregroundStyle(Color.green.opacity(0.8))
            }

            if !property.features.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(property.features, id: \.self) { f in
                            Text(f)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(Color.green.opacity(0.9))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(Color.green.opacity(0.12))
                                )
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(Color.green.opacity(0.25), lineWidth: 1)
                                )
                        }
                    }
                }
            }

            Text("Konum: \(property.latitude), \(property.longitude)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.green.opacity(0.25), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 8)
    }
}

#if DEBUG
#Preview {
    PropertyMapView(property: .previewSample)
}
#endif
