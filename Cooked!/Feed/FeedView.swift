import SwiftUI

struct FeedView: View {
    @ObservedObject public var vm: CameraViewModel
    
    var body: some View {
        if vm.posts.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.gray)
                
                Text("Upload a photo to show others what you are cooking!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        } else {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(vm.posts.sorted(by: { $0.timestamp > $1.timestamp })) { post in
                        PostView(post: post)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Post Image
            Image(uiImage: post.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 8) {
                // Caption
                Text(post.caption)
                    .font(.body)
                
                // Timestamp
                Text(post.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @StateObject var vm = CameraViewModel()
    NavigationStack {
        FeedView(vm: vm)
    }
}
