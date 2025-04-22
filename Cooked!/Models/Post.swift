import Foundation
import UIKit

struct Post: Identifiable {
    var id = UUID()
    var image: UIImage
    var caption: String
    var timestamp: Date
    var recipeId: String?  // ID from TheMealDB
    var rating: Int?       // 1-5 stars
    var review: String?    // Optional review text
}
