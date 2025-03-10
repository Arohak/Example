//
//  ProductDTO.swift
//  Example
//
//  Created by Ara Hakobyan on 3/10/25.
//

import Foundation
import SwiftData

@Model
final class Post {
    @Attribute(.unique) var id: Int
    var title: String
    var body: String
    var thumbnail: String?
    var price: Double?
    var createdAt: Date
    
    init(dto: PostDTO) {
        self.id = dto.id
        self.title = dto.title
        self.body = dto.body
        self.thumbnail = dto.thumbnail
        self.price = dto.price
        self.createdAt = Date()
    }
    
    public static let mock = Post(dto: .mock)
}
