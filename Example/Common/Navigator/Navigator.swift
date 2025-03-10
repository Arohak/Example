//
//  Navigator.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import Observation
import Foundation
import SwiftUI

@Observable
public final class Navigator<Route: Hashable> {
    public var route = [Route]()
    public init() {}
}

public extension Navigator {
    func pop() {
        route.removeLast()
    }
    
    func push(_ route: Route) {
        self.route.append(route)
    }
    
    func popToRoot() {
        route.removeAll()
    }
}
