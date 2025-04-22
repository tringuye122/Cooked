import SwiftUI

struct ContentView: View {
    @StateObject public var vm = CameraViewModel()
    
    // Holds the loaded image
    @State private var selectedImage: UIImage?
    
    // Control Camera sheet visibility
    @State private var showingCamera = false
    @State private var showingPhotoLibrary = false
    
    var body: some View {
        NavigationStack {
            TabView {
                // Home Tab - Display the feed
                Tab("Home", systemImage: "house") {
                    FeedView(vm: vm)
                }
                
                // Recipes Tab
                Tab("Recipes", systemImage: "magnifyingglass") {
                    RecipeView()
                }
            }
            .accentColor(.black)
            .navigationTitle("Cooked!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("Profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            showingCamera = true
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.black)
                        }
                        
                        Button(action: {
                            showingPhotoLibrary = true
                        }) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(image: $selectedImage, viewModel: vm)
            }
            .sheet(isPresented: $showingPhotoLibrary) {
                PhotoLibraryView(image: $selectedImage, viewModel: vm)
            }
            .onAppear {
                // Ensure tab bar is always visible
                UITabBar.appearance().backgroundColor = .systemBackground
                UITabBar.appearance().isTranslucent = false
            }
        }
    }
}

#Preview {
    ContentView()
}
