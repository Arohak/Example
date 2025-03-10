//
//  Story.swift
//  Example
//
//  Created by Ara Hakobyan on 3/10/25.
//


import Foundation
import SwiftData

@Model
final class Story {
    var id: Int
    var seen: Bool
    var title: String
    var categoryName: String
    var price: Double
    var thumbnail: String?

    public init(id: Int, seen: Bool, product: ProductDTO) {
        self.id = id
        self.seen = seen
        self.title = product.title
        self.categoryName = product.category.name
        self.price = product.price
        self.thumbnail = product.thumbnail
    }
    
    public static let mock = Story(id: 0, seen: false, product: .mock)
}
