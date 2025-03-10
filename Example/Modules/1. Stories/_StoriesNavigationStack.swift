//
//  StoriesNavigationStack.swift
//  Example
//
//  Created by Ara Hakobyan on 3/10/25.
//

import SwiftUI

extension StoriesScreen {
    @MainActor
    @ViewBuilder
    func destination(_ navigator: Navigator<StoriesScreen>, _ service: PlatziService) -> some View {
        switch self {
        case .list:
            StoriesFeedView(navigator: navigator, service: service)
        case let .item(id):
            StoryItemView(id: id, navigator: navigator, service: service)
        }
    }
}

public struct StoriesNavigationStack: View {
    @State private var navigator = Navigator<StoriesScreen>()
    @State private var platziService: PlatziService = .live

    public var body: some View {
        NavigationStack(path: $navigator.route) {
            StoriesFeedView(navigator: navigator, service: platziService)
                .navigationDestination(for: StoriesScreen.self) { $0.destination(navigator, platziService) }
        }
        .modelContainer(for: Story.self)
    }
}
