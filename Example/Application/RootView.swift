//
//  AppScreen.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

extension Screen: CaseIterable, Identifiable {
    public var id: Screen { self }
    
    public static var allCases = [Screen.stories(.list), .market(.categories), .posts(.list), .settings]
    
    var info: (title: String, icon: String) {
        switch self {
        case .stories: return ("Stories", "person.crop.circle.fill")
        case .market: return ("Market", "cart.fill")
        case .posts: return ("Posts", "photo.on.rectangle.fill")
        case .settings: return ("Settings", "gearshape.fill")
        }
    }
    
    
    @MainActor
    @ViewBuilder
    var destination: some View {
        switch self {
        case .stories: StoriesNavigationStack()
        case .market: MarketNavigationStack()
        case .posts:  PostNavigationStack()
        case .settings: ContentView()
        }
    }
}

struct RootView: View {
    @State var selection: Screen = .stories(.list)
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(Screen.allCases) { screen in
                screen.destination
                    .tag(screen)
                    .tabItem {
                        VStack {
                            Image(systemName: screen.info.icon)
                            Text(screen.info.title)
                        }
                    }
            }
        }
    }
}

#Preview {
    RootView()
}
