//
//  MarketProductsView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI
import SwiftData

public struct MarketProductsView: View {
    private let categoryID: Int?
    private let navigator: Navigator<MarketScreen>
    
    @State private var viewModel: MarketProductsViewModel

    public init(categoryID: Int?, navigator: Navigator<MarketScreen>, service: PlatziService) {
        self.categoryID = categoryID
        self.navigator = navigator
        _viewModel = State(initialValue: .init(service: service, categoryID: categoryID))
    }
    
    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.products.isEmpty {
                LoadingView()
            } else if let error = viewModel.state.errorMessage, viewModel.state.products.isEmpty {
                ContentUnavailableView {
                    Label("Failed to Load Products", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error)
                } actions: {
                    Button("Try Again") {
                        viewModel.fetchProducts(reset: true)
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 16)
                        ],
                        spacing: 16
                    ) {
                        ForEach(viewModel.state.products) { product in
                            ProductCard(product: product)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        navigator.push(.product(product.id))
                                    }
                                }
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        if !viewModel.state.products.isEmpty {
                            Group {
                                if viewModel.state.isLoadingMore {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                } else if viewModel.state.hasMorePages {
                                    Color.clear
                                        .frame(height: 50)
                                        .onAppear {
                                            viewModel.loadMoreProducts()
                                        }
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding()
                }
                .refreshable {
                    viewModel.fetchProducts(reset: true)
//                    await viewModel.refreshProducts()
                }
                .overlay {
                    if viewModel.state.products.isEmpty {
                        ContentUnavailableView {
                            Label("No Products", systemImage: "cart.badge.questionmark")
                        } description: {
                            Text("Try refreshing to see available products")
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.state.categoryName ?? "Products")
        .animation(.spring(response: 0.3), value: viewModel.state.products)
        .task {
            if viewModel.state.products.isEmpty {
                viewModel.fetchProducts(reset: true)
            }
        }
    }
}

#Preview {
    NavigationView {
        MarketProductsView(categoryID: 1, navigator: .init(), service: .mock)
    }
}




