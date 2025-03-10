//
//  StoryItemView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/11/25.
//


import SwiftUI

public struct StoryItemView: View {
    private let id: Int
    private let navigator: Navigator<StoriesScreen>
    private let service: PlatziService

    @State private var story: Story?
    
    public init(id: Int, navigator: Navigator<StoriesScreen>, service: PlatziService) {
        self.id = id
        self.navigator = navigator
        self.service = service
    }
    
    public var body: some View {
        ScrollView {
            if let story {
                StoryView(story: story)
            }
        }
        .navigationTitle("Story Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

public struct StoryView: View {
    let story: Story
    
    public var body: some View {
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
            HStack {
                Text("$\(String(format: "%.2f", story.price))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Button(action: {
                    // Add to cart functionality
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Add to Cart")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        StoryItemView(id: 1, navigator: .init(), service: .mock)
    }
}
