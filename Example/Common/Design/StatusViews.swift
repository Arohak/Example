//
//  StatusViews.swift
//  Example
//
//  Created by Claude AI on 3/15/25.
//

import SwiftUI

// MARK: - Error View

public struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    public init(message: String, retryAction: @escaping () -> Void) {
        self.message = message
        self.retryAction = retryAction
    }
    
    public var body: some View {
        ContentUnavailableView {
            Label("Failed to Load", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                retryAction()
            }
            .buttonStyle(.bordered)
        }
        .padding(.top, 50)
    }
}

// MARK: - Empty Content View

public struct EmptyContentView: View {
    let title: String
    let systemImage: String
    let description: String
    
    public init(title: String, systemImage: String, description: String) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }
    
    public var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            Text(description)
        }
    }
}

// MARK: - Loading View with Animation

public struct LoadingView: View {
    var message: String?
    
    public init(message: String? = nil) {
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            if let message = message {
                Text(message)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 50)
    }
}

#Preview {
    VStack(spacing: 30) {
        ErrorView(message: "Something went wrong") {
            print("Retry tapped")
        }
        
        EmptyContentView(
            title: "No Items Found",
            systemImage: "magnifyingglass",
            description: "Try adjusting your search or filters"
        )
        
        LoadingView(message: "Loading content...")
    }
} 