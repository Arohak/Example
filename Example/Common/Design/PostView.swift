//
//  PostView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

public struct PostView: View {
    let post: PostDTO

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Post Image
                Group {
                    if let thumbnail = post.thumbnail, let imageURL = URL(string: thumbnail), !thumbnail.isEmpty {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure(_):
                                Image(systemName: "photo")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Category badge
                Text("Category")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                // Title
                Text(post.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 4)
                
                // Body
                Text(post.body)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
                
                // Price
                HStack {
                    Text("Price:")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text("$\(String(format: "%.2f", post.price ?? 0))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    PostCard(post: .mock)
}

