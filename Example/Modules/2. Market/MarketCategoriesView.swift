//
//  MarketCategoriesView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

public struct MarketCategoriesView: View {
    private let navigator: Navigator<MarketScreen>
    private let service: PlatziService

    @State private var categories: [CategoryDTO] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    public init(navigator: Navigator<MarketScreen>, service: PlatziService) {
        self.navigator = navigator
        self.service = service
    }
    
    public var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    LoadingView()
                } else if let error = errorMessage {
                    VStack {
                        Text(error)
                            .foregroundStyle(.secondary)
                        
                        Button("Try Again") {
                            fetchCategories()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(categories) { category in
                                CategoryCard(category: category)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        let id: Int? = (categories.last?.name == category.name ? nil : category.id)
                                        navigator.push(.products(id))
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Categories")
        }
        .task {
            fetchCategories()
        }
    }
    
    private func fetchCategories() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                categories = try await service.categories()
                isLoading = false
            } catch {
                errorMessage = "Failed to load categories"
                isLoading = false
            }
        }
    }
}

struct CategoryCard: View {
    let category: CategoryDTO
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: category.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Image(systemName: "tag")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(category.name)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    MarketCategoriesView(navigator: .init(), service: .mock)
}

