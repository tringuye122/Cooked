//
//  RecipeViewModel.swift
//  Cooked!
//
//  Created by Tri Nguyen on 4/18/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {

    enum State {
        case idle
        case loading
        case loaded([Recipe])
        case error(Error)
    }
    
    @Published private(set) var state: State = .idle
    @Published var searchText = ""
    
    private let service = RecipeService()
    
    var recipes: [Recipe] {
        switch state {
        case .loaded(let recipes):
            return recipes
        default:
            return []
        }
    }
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    var error: Error? {
        if case .error(let error) = state {
            return error
        }
        return nil
    }
    
    func fetchRandomRecipes() async {
        // Only fetch if we don't have recipes yet
        if case .loaded = state { return }
        
        state = .loading
        
        do {
            let recipes = try await service.fetchRandomRecipes()
            state = .loaded(recipes)
        } catch {
            state = .error(error)
        }
    }
    
    func refreshRecipes() async {
        state = .loading
        
        do {
            let recipes = try await service.fetchRandomRecipes()
            state = .loaded(recipes)
        } catch {
            state = .error(error)
        }
    }
    
    func searchRecipes() async {
        guard !searchText.isEmpty else {
            state = .idle
            return
        }
        
        state = .loading
        
        do {
            let recipes = try await service.searchRecipes(query: searchText)
            state = .loaded(recipes)
        } catch {
            state = .error(error)
        }
    }
    
    func clearError() {
        if case .error = state {
            state = .idle
        }
    }
}
