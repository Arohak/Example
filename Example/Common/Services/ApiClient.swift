//
//  ApiClient.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import Foundation

enum ApiClient {
    static func fetch<T: Decodable>(for request: URLRequest) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }    
}
