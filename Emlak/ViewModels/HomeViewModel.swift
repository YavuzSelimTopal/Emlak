//
//  HomeViewModel.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var properties: [Property] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repo: PropertyRepositoryProtocol

    init(repo: PropertyRepositoryProtocol = PropertyRepository()) {
        self.repo = repo
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            properties = try await repo.fetchAll(limit: 60)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
