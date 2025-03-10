//
//  PlatziService.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import Foundation

public struct PlatziService: Sendable {
    public let categories: @Sendable () async throws -> [CategoryDTO]
    public let products: @Sendable (Int?, Page) async throws -> [ProductDTO]
    public let product: @Sendable (Int) async throws -> ProductDTO
    
    private static let urlString = "https://api.escuelajs.co/api/v1/"

    public static let live = Self(
        categories: {
            let url = URL(string: "\(urlString)categories")!
            return try await ApiClient.fetch(from: url)
        },
        products: { categoryID, page in
            let path = categoryID.map { "categories/\($0)/products" } ?? "products"
            let url = URL(string: urlString + path)!
                .appending("offset", value: page.offset)
                .appending("limit", value: page.limit)
            return try await ApiClient.fetch(from: url)
        },
        product: { id in
            let url = URL(string: "\(urlString)products/\(id)")!
            return try await ApiClient.fetch(from: url)
        }
    )
    
    static let mock = Self(
        categories: { Array(repeating: .mock, count: 10) },
        products: { _, _ in Array(repeating: .mock, count: 20) },
        product: { _ in .mock }
    )
}

private extension URL {
    func appending(_ queryItem: String, value: Int) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: queryItem, value: String(value)))
        components.queryItems = items
        return components.url!
    }
}

public struct CategoryDTO: Identifiable, Decodable, Hashable, Sendable {
    public let id: Int
    let name: String
    let image: String
    
    public static let mock = Self(id: 1, name: "iPhone", image: "Apple")
}

public struct ProductDTO: Identifiable, Decodable, Hashable, Sendable {
    public let id: Int
    let title: String
    let description: String
    let price: Double
    let category: CategoryDTO
    let images: [String]
    
    var thumbnail: String? {
        images.first
    }
    
    public static let mock = Self(id: 1, title: "iPhone", description: "Apple", price: 1000, category: .mock, images: ["https://api.escuelajs.co/api/v1/products/1/image"])
}
