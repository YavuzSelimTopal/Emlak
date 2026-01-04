//
//  PropertyRepository.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import Foundation
import FirebaseFirestore

protocol PropertyRepositoryProtocol {
    func fetchAll(limit: Int) async throws -> [Property]
    func searchByKeyword(_ keyword: String, limit: Int) async throws -> [Property]
    func recommend(budget: Int, desiredFeatures: [String], limit: Int) async throws -> [Property]
}

final class PropertyRepository: PropertyRepositoryProtocol {
    private let db = FirebaseManager.shared.db

    func fetchAll(limit: Int = 50) async throws -> [Property] {
        let snap = try await db.collection("properties")
            .order(by: "price", descending: false)
            .limit(to: limit)
            .getDocuments()

        return try snap.documents.compactMap { doc in
            try doc.data(as: Property.self)
        }
    }

    /// Firestore "contains" araması yok. Bu yüzden searchKeywords alanı üzerinden arrayContains kullanıyoruz.
    func searchByKeyword(_ keyword: String, limit: Int = 50) async throws -> [Property] {
        let normalized = Self.normalize(keyword)
        guard !normalized.isEmpty else { return [] }

        let snap = try await db.collection("properties")
            .whereField("searchKeywords", arrayContains: normalized)
            .limit(to: limit)
            .getDocuments()

        return try snap.documents.compactMap { try $0.data(as: Property.self) }
    }

    /// Basit öneri mantığı:
    /// 1) bütçeye yakın aralık (<= bütçe, >= bütçenin %70'i)
    /// 2) features eşleşmesine göre skorla
    func recommend(budget: Int, desiredFeatures: [String], limit: Int = 20) async throws -> [Property] {
        let minPrice = Int(Double(budget) * 0.70)

        // Firestore’da iki eşitsizlik aynı field’da yapılmalı → price üzerinde yapıyoruz.
        let snap = try await db.collection("properties")
            .whereField("price", isLessThanOrEqualTo: budget)
            .whereField("price", isGreaterThanOrEqualTo: minPrice)
            .limit(to: 80) // önce geniş çek, sonra client-side skorla
            .getDocuments()

        let items = try snap.documents.compactMap { try $0.data(as: Property.self) }

        let desired = desiredFeatures.map(Self.normalize)

        let scored: [(Property, Int)] = items.map { p in
            let feats = p.features.map(Self.normalize)
            let matches = desired.filter { feats.contains($0) }.count
            // fiyat yakınlığı bonusu
            let diff = abs(budget - p.price)
            let priceBonus = max(0, 20 - diff / max(1, budget / 20))
            return (p, matches * 50 + priceBonus)
        }

        return scored
            .sorted { $0.1 > $1.1 }
            .prefix(limit)
            .map { $0.0 }
    }

    static func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: "ı", with: "i")
            .replacingOccurrences(of: "ğ", with: "g")
            .replacingOccurrences(of: "ü", with: "u")
            .replacingOccurrences(of: "ş", with: "s")
            .replacingOccurrences(of: "ö", with: "o")
            .replacingOccurrences(of: "ç", with: "c")
    }
}
