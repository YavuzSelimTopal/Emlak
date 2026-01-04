//
//  SearchViewModel.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [Property] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repo: PropertyRepositoryProtocol

    init(repo: PropertyRepositoryProtocol = PropertyRepository()) {
        self.repo = repo
    }

    func search() async {
        isLoading = true
        errorMessage = nil
        do {
            results = try await repo.searchByKeyword(query, limit: 60)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func clear() {
        results = []
    }
}
