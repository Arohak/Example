//
//  Styles.swift
//  Example
//
//  Created by Claude AI on 3/15/25.
//

import SwiftUI

// MARK: - Card Style

public struct CardStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Badge Style

public struct BadgeStyle: ViewModifier {
    var color: Color
    
    public init(color: Color = .orange) {
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.caption.weight(.medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(Capsule())
    }
}

// MARK: - Price Style

public struct PriceStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.blue)
    }
}

// MARK: - Action Button Style

public struct ActionButtonStyle: ViewModifier {
    var backgroundColor: Color
    
    public init(backgroundColor: Color = .blue) {
        self.backgroundColor = backgroundColor
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Async Image Style

public struct AsyncImageStyle: ViewModifier {
    var height: CGFloat? = nil
    var contentMode: ContentMode = .fill
    
    public init(height: CGFloat? = nil, contentMode: ContentMode = .fill) {
        self.height = height
        self.contentMode = contentMode
    }
    
    public func body(content: Content) -> some View {
        content
            .frame(height: height)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - View Extensions

public extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func badgeStyle(color: Color = .orange) -> some View {
        modifier(BadgeStyle(color: color))
    }
    
    func priceStyle() -> some View {
        modifier(PriceStyle())
    }
    
    func actionButtonStyle(backgroundColor: Color = .blue) -> some View {
        modifier(ActionButtonStyle(backgroundColor: backgroundColor))
    }
    
    func asyncImageStyle(height: CGFloat? = nil, contentMode: ContentMode = .fill) -> some View {
        modifier(AsyncImageStyle(height: height, contentMode: contentMode))
    }
} 