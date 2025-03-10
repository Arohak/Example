//
//  PostService.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import Foundation

// struct implementation
public struct PostService: Sendable {
    public let list: @Sendable () async throws -> [PostDTO]
    public let item: @Sendable (Int) async throws -> PostDTO
}

public extension PostService {
    private static let urlString = "https://jsonplaceholder.typicode.com/posts/"
                  
    static let live = Self(
        list: {
            let url = URL(string: urlString)!
            return try await ApiClient.fetch(from: url)
        },
        item: {
            let url = URL(string: "\(urlString)\($0)")!
            return try await ApiClient.fetch(from: url)
        }
    )
    
    static let mock = Self(
        list: { Array(repeating: .mock, count: 20) },
        item: { _ in .mock }
    )
}

// protocol implementation
public protocol IPostService: Sendable {
    func items() async throws -> [PostDTO]
    func item(by id: Int) async throws -> PostDTO
}

public actor PostService2: IPostService {
    private let urlString = "https://jsonplaceholder.typicode.com/posts/"

    public func items() async throws -> [PostDTO] {
        let url = URL(string: urlString)!
        return try await ApiClient.fetch(from: url)
    }
    
    public func item(by id: Int) async throws -> PostDTO {
        let url = URL(string: "\(urlString)\(id)")!
        return try await ApiClient.fetch(from: url)
    }
}

public actor MockPostService: IPostService {
    public func items() async throws -> [PostDTO] {
        Array(repeating: .mock, count: 20)
    }
    
    public func item(by id: Int) async throws -> PostDTO {
        .mock
    }
}

// DTO
public struct PostDTO: Identifiable, Decodable {
    public let id: Int
    public let title: String
    public let body: String
    public var thumbnail: String?
    public var price: Double?
    
    public static let mock = Self(id: 1, title: "iPhone", body: "Apple")
}
