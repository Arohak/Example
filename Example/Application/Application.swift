//
//  ExampleApp.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI
import SwiftData

@main
struct Application: App {
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [Story.self, Post.self, Item.self], inMemory: false)
    }
}
