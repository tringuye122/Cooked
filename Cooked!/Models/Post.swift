import Foundation
import UIKit

struct Post: Identifiable {
    var id = UUID()
    var image: UIImage
    var caption: String
    var timestamp: Date
}
