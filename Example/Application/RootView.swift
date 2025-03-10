//
//  AppScreen.swift
//  Example
//
//  Created by Ara Hakobyan on 3/9/25.
//

import SwiftUI

extension Screen: CaseIterable, Identifiable {
    public var id: Screen { self }
    
    public static var allCases = [Screen.home(.list), .market(.categories), .settings]
    
    var info: (title: String, icon: String) {
        switch self {
        case .home: return ("Home", "house")
        case .market: return ("Market", "cart.fill")
        case .settings: return ("Settings", "gearshape.fill")
        }
    }
    
    
    @MainActor
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:  HomeNavigationStack()
        case .market: MarketNavigationStack()
        case .settings: ContentView()
        }
    }
}

struct RootView: View {
    @State var selection: Screen = .home(.list)
    
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
