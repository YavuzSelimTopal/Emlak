//
//  RecommendViewModel.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI
import Combine

@MainActor
final class RecommendViewModel: ObservableObject {
    @Published var budgetText: String = ""
    @Published var selectedFeatures: Set<String> = []
    @Published var results: [Property] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // örnek özellik havuzu (istersen Firestore’dan da çekebiliriz)
    let featurePool: [String] = [
        "Yeni boyanmış", "Balkon", "Asansör", "Otopark", "Eşyalı", "Deniz manzaralı", "Metroya yakın"
    ]

    private let repo: PropertyRepositoryProtocol

    init(repo: PropertyRepositoryProtocol = PropertyRepository()) {
        self.repo = repo
    }

    func recommend() async {
        errorMessage = nil
        guard let budget = Int(budgetText.filter({ $0.isNumber })), budget > 0 else {
            errorMessage = "Lütfen geçerli bir bütçe gir."
            return
        }

        isLoading = true
        do {
            results = try await repo.recommend(
                budget: budget,
                desiredFeatures: Array(selectedFeatures),
                limit: 30
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
