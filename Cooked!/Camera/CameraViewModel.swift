import Foundation
import UIKit

class CameraViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    // Add a new post with optional custom timestamp
    func addPost(image: UIImage, caption: String, timestamp: Date = Date()) {
        let newPost = Post(image: image, caption: caption, timestamp: timestamp)
        posts.append(newPost)
    }
}
