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
        VStack(spacing: 0) {
            Map(position: $position) {
                Annotation(property.address, coordinate: property.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                }
            }
            .frame(height: 380)

            VStack(alignment: .leading, spacing: 8) {
                Text(property.address).font(.headline)
                Text("\(property.price) ₺").font(.title3.weight(.semibold))

                if !property.features.isEmpty {
                    Text("Özellikler: " + property.features.joined(separator: ", "))
                        .foregroundStyle(.secondary)
                }

                Text("Konum: \(property.latitude), \(property.longitude)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(16)

            Spacer()
        }
        .navigationTitle("Harita")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    PropertyMapView(property: .previewSample)
}
#endif
