//
//  Screen.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

public enum Screen: Hashable, Sendable {
    case home(HomeScreen)
    case market(MarketScreen)
    case settings
}

public enum HomeScreen: Hashable, Sendable {
    case list, item(Int)
}

public enum MarketScreen: Hashable, Sendable {
    case categories, products(Int?), product(Int)
}
