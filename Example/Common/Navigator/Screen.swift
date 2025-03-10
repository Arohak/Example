//
//  Screen.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

public enum Screen: Hashable, Sendable {
    case stories(StoriesScreen)
    case market(MarketScreen)
    case posts(PostScreen)
    case settings
}

public enum StoriesScreen: Hashable, Sendable {
    case list, item(Int)
}

public enum PostScreen: Hashable, Sendable {
    case list, item(Int)
}

public enum MarketScreen: Hashable, Sendable {
    case categories, products(Int?), product(Int)
}
