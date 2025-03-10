//
//  Page.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import Foundation

public struct Page: Equatable, Sendable {
    public let offset: Int
    public let limit: Int
    
    public init(offset: Int = 0, limit: Int = 3) {
        self.offset = offset
        self.limit = limit
    }
    
    public static let `default` = Page()
    
    public var next: Page {
        Page(offset: offset + limit, limit: limit)
    }
} 
