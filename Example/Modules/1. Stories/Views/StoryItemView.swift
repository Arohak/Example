//
//  StoryItemView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/11/25.
//


import SwiftUI
import SwiftData

public struct StoryItemView: View {
    private let id: Int
    private let navigator: Navigator<StoriesScreen>
    private let service: PlatziService
    
    @Environment(\.modelContext) private var modelContext
    @State private var story: Story?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    public init(id: Int, navigator: Navigator<StoriesScreen>, service: PlatziService) {
        self.id = id
        self.navigator = navigator
        self.service = service
    }
    
    public var body: some View {
        ScrollView {
            if isLoading {
                LoadingView()
            } else if let error = errorMessage {
                ContentUnavailableView {
                    Label("Failed to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error)
                } actions: {
                    Button("Try Again") {
                        loadStory()
                    }
                    .buttonStyle(.bordered)
                }
            } else if let story = story {
                VStack(alignment: .leading, spacing: 20) {
                    if let thumbnail = story.thumbnail {
                        AsyncImage(url: URL(string: thumbnail)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure(_):
                                Image(systemName: "photo")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.secondary)
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    // Category
                    Text(story.categoryName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    // Title
                    Text(story.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Price
                    Text("$\(String(format: "%.2f", story.price))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                    
                    // Seen status
                    HStack {
                        Text("Status:")
                            .fontWeight(.medium)
                        
                        Text(story.seen ? "Seen" : "Not seen yet")
                            .foregroundStyle(story.seen ? .green : .blue)
                            .fontWeight(story.seen ? .regular : .bold)
                        
                        Spacer()
                        
                        Button(action: {
                            toggleSeenStatus(story)
                        }) {
                            Label(
                                story.seen ? "Mark as Unseen" : "Mark as Seen",
                                systemImage: story.seen ? "eye.slash" : "eye"
                            )
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .animation(.spring(response: 0.3), value: story.seen)
            } else {
                ContentUnavailableView {
                    Label("Story Not Found", systemImage: "questionmark.circle")
                } description: {
                    Text("The requested story could not be found.")
                }
            }
        }
        .navigationTitle("Story Details")
        .task {
            loadStory()
        }
    }
    
    private func loadStory() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Try to fetch from local database first
                let descriptor = FetchDescriptor<Story>(predicate: #Predicate<Story> { story in
                    story.id == id
                })
                
                let localStories = try modelContext.fetch(descriptor)
                
                if let localStory = localStories.first {
                    // Found in local database
                    await MainActor.run {
                        self.story = localStory
                        self.isLoading = false
                        print("Loaded story \(id) from local database")
                    }
                } else {
                    // Not found locally, try to fetch from network
                    print("Story \(id) not found locally, fetching from network")
                    let product = try await service.product(id)
                    
                    await MainActor.run {
                        let newStory = Story(id: product.id, seen: false, product: product)
                        modelContext.insert(newStory)
                        try? modelContext.save()
                        
                        self.story = newStory
                        self.isLoading = false
                        print("Loaded story \(id) from network and saved to database")
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load story"
                    self.isLoading = false
                    print("Error loading story: \(error)")
                }
            }
        }
    }
    
    private func toggleSeenStatus(_ story: Story) {
        story.seen.toggle()
        
        do {
            try modelContext.save()
            print("Updated seen status for story \(story.id) to \(story.seen)")
        } catch {
            print("Failed to update seen status: \(error)")
        }
    }
}

#Preview {
    NavigationView {
        StoryItemView(id: 1, navigator: .init(), service: .mock)
    }
}
