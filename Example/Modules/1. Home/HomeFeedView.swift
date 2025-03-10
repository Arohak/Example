//
//  HomeFeedView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI
import SwiftData

public struct HomeFeedView: View {
    @Environment(\.navigator) private var navigator: Navigator<HomeScreen>
    @Environment(\.postService) private var service: PostService
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Post.createdAt, order: .reverse) private var posts: [Post]
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    public var body: some View {
        NavigationView {
            Group {
                if isLoading && posts.isEmpty {
                    LoadingView()
                } else if let error = errorMessage, posts.isEmpty {
                    ContentUnavailableView {
                        Label("Failed to Load Posts", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error)
                    } actions: {
                        Button("Try Again") {
                            fetchPosts()
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    ScrollView {
                        PostGridView(posts: posts) { post in
                            navigator.push(.item(post.id))
                        }
                    }
                    .refreshable {
                        await refreshPosts()
                    }
                    .overlay {
                        if posts.isEmpty {
                            ContentUnavailableView {
                                Label("No Posts", systemImage: "doc.text.image")
                            } description: {
                                Text("Try refreshing to see available posts")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .task {
                if posts.isEmpty {
                    fetchPosts()
                }
            }
        }
    }
}

extension HomeFeedView {
    private func fetchPosts() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let dtoPosts = try await service.list()
                // Insert or update posts
                dtoPosts.forEach { dto in
                    // Check if post already exists
                    if let existingPost = posts.first(where: { $0.id == dto.id }) {
                        // Update existing post
                        existingPost.title = dto.title
                        existingPost.body = dto.body
                        existingPost.thumbnail = dto.thumbnail
                        existingPost.price = dto.price
                    } else {
                        // Insert new post
                        modelContext.insert(Post(dto: dto))
                    }
                }
                
                // Remove posts that no longer exist
                let dtoIds = Set(dtoPosts.map(\.id))
                posts.filter { !dtoIds.contains($0.id) }
                    .forEach { modelContext.delete($0) }
                
                try? modelContext.save()
                isLoading = false
            } catch {
                errorMessage = "Failed to load posts"
                isLoading = false
            }
        }
    }
    
    private func refreshPosts() async {
        await withCheckedContinuation { continuation in
            fetchPosts()
            continuation.resume()
        }
    }
}

#Preview {
    HomeFeedView()
        .modelContainer(for: Post.self, inMemory: true)
}
