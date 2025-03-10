//
//  StoryCard.swift
//  Example
//
//  Created by Ara Hakobyan on 3/11/25.
//

import SwiftUI

struct StoryCard: View {
    let story: Story
    var onToggleSeen: () -> Void
    
    @State private var isImageLoaded = false
    
    var body: some View {
        VStack {
            // Image section with seen/unseen indicator
            imageSection
            
            // Content section
            contentSection
        }
        .cardStyle()
        .animation(.spring(response: 0.3), value: isImageLoaded)
        .animation(.spring(response: 0.3), value: story.seen)
    }
    
    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: story.thumbnail ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onAppear { isImageLoaded = true }
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.secondary)
                        .padding()
                        .onAppear { isImageLoaded = true }
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            // Seen/unseen indicator
            Circle()
                .fill(story.seen ? Color.gray.opacity(0.7) : Color.blue)
                .frame(width: 16, height: 16)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding(8)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Category badge
            Text(story.categoryName)
                .font(.caption.weight(.medium))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.accentColor)
                .clipShape(Capsule())
            
            // Title
            Text(story.title)
                .font(.headline)
                .lineLimit(2)
                .opacity(isImageLoaded ? 1 : 0)
            
            // Price and seen/unseen button
            HStack {
                Text("$\(String(format: "%.2f", story.price))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Button(action: onToggleSeen) {
                    HStack {
                        Image(systemName: story.seen ? "eye.slash" : "eye")
                        Text(story.seen ? "Mark as Unseen" : "Mark as Seen")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(story.seen ? Color.gray : Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
    }
} 
