//
//  HomeNavigationStack.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

extension HomeScreen {
    @MainActor
    @ViewBuilder
    var destination: some View {
        switch self {
        case .list:
            HomeFeedView()
        case let .item(id):
            HomeDetailsView(postId: id)
        }
    }
}

public struct HomeNavigationStack: View {
    @State private var navigator = Navigator<HomeScreen>()
    @State private var postService: PostService = .live

    public var body: some View {
        NavigationStack(path: $navigator.route) {
            HomeFeedView()
                .navigationDestination(for: HomeScreen.self) { $0.destination }
        }
//        .modelContainer(for: Post.self)
        .environment(\.postService, postService)
        .environment(\.navigator, navigator)
    }
}


public extension EnvironmentValues {
    @Entry var postService: PostService = .mock
    @Entry var navigator: Navigator<HomeScreen> = .init()
}
