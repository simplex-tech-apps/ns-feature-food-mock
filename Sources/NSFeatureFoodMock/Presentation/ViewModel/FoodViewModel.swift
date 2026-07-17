//
//  FoodViewModel.swift
//  NSFeatureFood
//
//  Created by apple on 07/07/26.
//
import SwiftUI
import SwiftData

@MainActor
@Observable
public class FoodViewModel: Hashable {    
    // MARK: - Hashable Implementation
    /// Must be marked `nonisolated` so it can be called safely outside the MainActor context.
    public nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
        
    // MARK: - Equatable Implementation
    /// Must be marked `nonisolated` to compare class pointers safely.
    public static nonisolated func == (lhs: FoodViewModel, rhs: FoodViewModel) -> Bool {
        lhs === rhs
    }
}
