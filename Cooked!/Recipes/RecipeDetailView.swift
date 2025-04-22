import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Recipe Image
                AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 300)
                .clipped()
                
                VStack(alignment: .leading, spacing: 24) {
                    // Recipe Title and Category
                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.strMeal)
                            .font(.title)
                            .bold()
                            .lineLimit(2)
                        
                        if let category = recipe.strCategory {
                            Text(category)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(recipe.ingredients, id: \.ingredient) { ingredient, measure in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 8, height: 8)
                                    Text("\(measure) \(ingredient)")
                                        .font(.body)
                                }
                            }
                        }
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instructions")
                            .font(.title2)
                            .bold()
                        
                        if let instructions = recipe.strInstructions {
                            Text(instructions)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(4)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe(
            idMeal: "1",
            strMeal: "Test Recipe",
            strMealThumb: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg",
            strCategory: "Test Category",
            strArea: "Test Area",
            strInstructions: "Test instructions",
            strIngredient1: "Ingredient 1",
            strIngredient2: "Ingredient 2",
            strIngredient3: "Ingredient 3",
            strIngredient4: "Ingredient 4",
            strIngredient5: "Ingredient 5",
            strIngredient6: "Ingredient 6",
            strIngredient7: "Ingredient 7",
            strIngredient8: "Ingredient 8",
            strIngredient9: "Ingredient 9",
            strIngredient10: "Ingredient 10",
            strMeasure1: "1 cup",
            strMeasure2: "1 cup",
            strMeasure3: "1 cup",
            strMeasure4: "1 cup",
            strMeasure5: "1 cup",
            strMeasure6: "1 cup",
            strMeasure7: "1 cup",
            strMeasure8: "1 cup",
            strMeasure9: "1 cup",
            strMeasure10: "2 tbsp"
        ))
    }
} 
