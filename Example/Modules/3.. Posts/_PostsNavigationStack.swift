//
//  PostsNavigationStack.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

extension PostScreen {
    @MainActor
    @ViewBuilder
    var destination: some View {
        switch self {
        case .list:
            PostFeedView()
        case let .item(id):
            PostDetailsView(postId: id)
        }
    }
}

public struct PostNavigationStack: View {
    @State private var navigator = Navigator<PostScreen>()
    @State private var postService: PostService = .live

    public var body: some View {
        NavigationStack(path: $navigator.route) {
            PostFeedView()
                .navigationDestination(for: PostScreen.self) { $0.destination }
        }
        .modelContainer(for: Post.self)
        .environment(\.postService, postService)
        .environment(\.navigator, navigator)
    }
}

public extension EnvironmentValues {
    @Entry var postService: PostService = .mock
    @Entry var navigator: Navigator<PostScreen> = .init()
}
