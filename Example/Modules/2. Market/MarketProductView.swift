//
//  MarketProductView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

public struct MarketProductView: View {
    private let productID: Int
    private let navigator: Navigator<MarketScreen>
    private let service: PlatziService

    @State private var product: ProductDTO?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedImageIndex = 0
    
    public init(productID: Int, navigator: Navigator<MarketScreen>, service: PlatziService) {
        self.productID = productID
        self.navigator = navigator
        self.service = service
    }
    
    public var body: some View {
        ScrollView {
            if isLoading {
                LoadingView()
                    .padding(.top, 100)
            } else if let error = errorMessage {
                VStack {
                    Text(error)
                        .foregroundStyle(.secondary)
                    
                    Button("Try Again") {
                        fetchProduct()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
                .padding(.top, 100)
            } else if let product = product {
                VStack(alignment: .leading, spacing: 20) {
                    // Image gallery
                    TabView(selection: $selectedImageIndex) {
                        ForEach(0..<product.images.count, id: \.self) { index in
                            AsyncImage(url: URL(string: product.images[index])) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                case .failure(_):
                                    Image(systemName: "photo")
                                        .font(.system(size: 60))
                                        .foregroundStyle(.secondary)
                                case .empty:
                                    ProgressView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .tag(index)
                        }
                    }
                    .frame(height: 300)
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Category badge
                    Text(product.category.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    // Title
                    Text(product.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Price
                    HStack {
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                        
                        Spacer()
                        
                        Button(action: {
                            // Add to cart functionality
                        }) {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                Text("Add to Cart")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    
                    // Description header
                    Text("Description")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    // Description
                    Text(product.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle(product?.title ?? "Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            fetchProduct()
        }
    }
    
    private func fetchProduct() {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        Task {
            do {
                product = try await service.product(productID)
                isLoading = false
            } catch {
                errorMessage = "Failed to load product details"
                isLoading = false
            }
        }
    }
}

#Preview {
    NavigationView {
        MarketProductView(productID: 1, navigator: .init(), service: .mock)
    }
}

