//
//  RecipeService.swift
//  Cooked!
//
//  Created by Tri Nguyen on 4/18/25.
//

import Foundation

class RecipeService {
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    private let apiKey = "1" // Test API key
    
    func fetchRandomRecipes(count: Int = 10) async throws -> [Recipe] {
        var recipes: [Recipe] = []
        
        for _ in 0..<count {
            let url = URL(string: "\(baseURL)/random.php")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
            if let recipe = response.meals.first {
                recipes.append(recipe)
            }
        }
        
        return recipes
    }
    
    func searchRecipes(query: String) async throws -> [Recipe] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "\(baseURL)/search.php?s=\(encodedQuery)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return response.meals
    }
    
    func fetchRecipeDetails(id: String) async throws -> Recipe? {
        let url = URL(string: "\(baseURL)/lookup.php?i=\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return response.meals.first
    }
}
