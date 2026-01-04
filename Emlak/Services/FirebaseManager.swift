//
//  FirebaseManager.swift
//  Emlak
//
//  Created by MACim on 3.01.2026.
//

import FirebaseFirestore
import FirebaseStorage

final class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}

    let db = Firestore.firestore()
    let storage = Storage.storage()
}
