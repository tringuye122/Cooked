//
//  RecipeView.swift
//  Cooked!
//
//  Created by Tri Nguyen on 4/18/25.
//

import SwiftUI

struct RecipeView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack(spacing: 12) {
                    TextField("Search recipes...", text: $viewModel.searchText)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            Task {
                                await viewModel.searchRecipes()
                            }
                        }
                    
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                
                // Content based on state
                switch viewModel.state {
                case .idle:
                    EmptyView()
                    
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .loaded(let recipes):
                    if recipes.isEmpty {
                        emptyStateView
                    } else {
                        recipeList(recipes)
                    }
                    
                case .error(let error):
                    errorView(error)
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchRandomRecipes()
            }
        }
    }
        
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 60))
                .foregroundStyle(.gray)
            Text("No recipes found")
                .font(.headline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            Text(error.localizedDescription)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again") {
                Task {
                    await viewModel.fetchRandomRecipes()
                }
            }
            .buttonStyle(.bordered)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func recipeList(_ recipes: [Recipe]) -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        RecipeCard(recipe: recipe, averageRating: nil)
                    }
                }
                
                // Refresh Button
                Button {
                    Task {
                        await viewModel.refreshRecipes()
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Load New Recipes")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    let averageRating: Double?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.strMeal)
                    .font(.headline)
                    .lineLimit(2)
                
                if let category = recipe.strCategory {
                    Text(category)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                if let rating = averageRating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", rating))
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    RecipeView()
}
