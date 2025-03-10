//
//  StoryCard.swift
//  Example
//
//  Created by Ara Hakobyan on 3/11/25.
//

import SwiftUI

struct StoryCard: View {
    let story: Story

    @State private var isImageLoaded = false
    
    var body: some View {
        VStack {
            // Image section
            AsyncImage(url: URL(string: story.thumbnail ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onAppear { isImageLoaded = true }
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 8) {
                // Category badge
                Text(story.categoryName)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
                
                // Title and description
                Group {
                    Text(story.title)
                        .font(.headline)
                        .lineLimit(2)
                }
                .opacity(isImageLoaded ? 1 : 0)
                
                // Price
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
                            Text("Seen")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding()
        }
        .cardStyle()
        .animation(.spring(response: 0.3), value: isImageLoaded)
    }
} 
