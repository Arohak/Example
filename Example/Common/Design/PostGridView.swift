//
//  PostGridView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

public struct PostGridView: View {
    let posts: [Post]
    let onTapPost: (Post) -> Void
    
    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(posts) { post in
                    PostCard(post: post)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onTapPost(post)
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
        .refreshable {
            // Add pull-to-refresh functionality
            await Task.yield() // Placeholder for actual refresh logic
        }
    }
}
