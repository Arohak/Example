//
//  PostDetailsView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

public struct PostDetailsView: View {
    let postId: Int

    @Environment(\.navigator) private var navigator: Navigator<PostScreen>
    @Environment(\.postService) private var service: PostService

    @State private var post: PostDTO?
    
    var isLoading: Bool { post == nil }
    
    public var body: some View {
        VStack {
            if let post {
                PostView(post: post)
            } else {
                LoadingView()
            }
            
            VStack {
                ZStack {
                    ProgressView()
                        .controlSize(.regular)
                        .tint(.blue)
                        .opacity(isLoading ? 1 : 0)
                    
                    Button("Refresh") {
                        fetchPost()
                    }
                    .buttonStyle(.plain)
                    .opacity(isLoading ? 0 : 1)
                }
                .padding()
                
                HStack {
                    Button("Back") {
                        navigator.pop()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Root") {
                        navigator.popToRoot()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding(.horizontal)
        .task {
            fetchPost()
        }
    }
}

extension PostDetailsView {
    func fetchPost() {
        post = nil
        
        Task {
            try await Task.sleep(for: .seconds(1))
            post = try await service.item(postId)
        }
    }
}

#Preview {
    PostDetailsView(postId: 1)
}
