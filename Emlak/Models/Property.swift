//
//  Property.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Property: Identifiable, Codable {
    @DocumentID var id: String?
    var address: String
    var neighborhood: String
    var street: String
    var price: Int
    var latitude: Double
    var longitude: Double
    var features: [String]
    var imageURLs: [String]
    var searchKeywords: [String]?

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
