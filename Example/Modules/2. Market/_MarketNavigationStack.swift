//
//  MarketNavigationStack.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//


import SwiftUI

extension MarketScreen {
    @MainActor
    @ViewBuilder
    func destination(_ navigator: Navigator<MarketScreen>, _ service: PlatziService) -> some View {
        switch self {
        case .categories:
            MarketCategoriesView(navigator: navigator, service: service)
        case let .products(id):
            MarketProductsView(categoryID: id, navigator: navigator, service: service)
        case let .product(id):
            MarketProductView(productID: id, navigator: navigator, service: service)
        }
    }
}

public struct MarketNavigationStack: View {
    @State private var navigator = Navigator<MarketScreen>()
    @State private var platziService: PlatziService = .live

    public var body: some View {
        NavigationStack(path: $navigator.route) {
            MarketCategoriesView(navigator: navigator, service: platziService)
                .navigationDestination(for: MarketScreen.self) { $0.destination(navigator, platziService) }
        }
    }
}
