//
//  GenericProductCard.swift
//  Example
//
//  Created by Claude AI on 3/15/25.
//

import SwiftUI

public struct GenericProductCard<T>: View {
    let item: T
    let imageURL: String?
    let title: String
    let category: String
    let price: Double
    let onTap: () -> Void
    let actionButton: (() -> AnyView)?
    let toggleAction: (() -> Void)?
    let toggleState: Bool?
    
    @State private var isImageLoaded = false
    
    public var body: some View {
        VStack {
            // Image section
            ZStack(alignment: .topTrailing) {
                AsyncImageView(
                    urlString: imageURL,
                    height: 200,
                    onImageLoaded: { isImageLoaded = true }
                )
                
                // Optional slot for indicators or badges
                if let actionButton = actionButton {
                    actionButton()
                        .padding(8)
                }
            }
            
            // Content section
            VStack(alignment: .leading, spacing: 8) {
                // Category badge
                Text(category)
                    .badgeStyle()
                
                // Title
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                    .opacity(isImageLoaded ? 1 : 0)
                
                // Price and optional toggle button
                HStack {
                    Text("$\(String(format: "%.2f", price))")
                        .priceStyle()
                    
                    Spacer()
                    
                    if let toggleAction = toggleAction, let toggleState = toggleState {
                        Button(action: toggleAction) {
                            HStack {
                                Image(systemName: toggleState ? "eye.slash" : "eye")
                                Text(toggleState ? "Mark as Unseen" : "Mark as Seen")
                            }
                            .actionButtonStyle(backgroundColor: toggleState ? .gray : .blue)
                        }
                    }
                }
            }
            .padding()
        }
        .cardStyle()
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .animation(.spring(response: 0.3), value: isImageLoaded)
        .animation(.spring(response: 0.3), value: toggleState)
    }
    
    // MARK: - Base initializer
    public init(
        item: T,
        imageURL: String?,
        title: String,
        category: String,
        price: Double,
        onTap: @escaping () -> Void,
        actionButton: (() -> AnyView)? = nil,
        toggleAction: (() -> Void)? = nil,
        toggleState: Bool? = nil
    ) {
        self.item = item
        self.imageURL = imageURL
        self.title = title
        self.category = category
        self.price = price
        self.onTap = onTap
        self.actionButton = actionButton
        self.toggleAction = toggleAction
        self.toggleState = toggleState
    }
}

// MARK: - Factory methods
// These are not part of the public API but provide convenience for internal use

extension GenericProductCard {
    static func makeFromProduct(_ product: ProductDTO, onTap: @escaping () -> Void) -> GenericProductCard<ProductDTO> {
        GenericProductCard<ProductDTO>(
            item: product,
            imageURL: product.thumbnail,
            title: product.title,
            category: product.category.name,
            price: product.price,
            onTap: onTap
        )
    }
    
    static func makeFromStory(_ story: Story, onTap: @escaping () -> Void, onToggleSeen: @escaping () -> Void) -> GenericProductCard<Story> {
        GenericProductCard<Story>(
            item: story,
            imageURL: story.thumbnail,
            title: story.title,
            category: story.categoryName,
            price: story.price,
            onTap: onTap,
            actionButton: {
                AnyView(
                    Circle()
                        .fill(story.seen ? Color.gray.opacity(0.7) : Color.blue)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                )
            },
            toggleAction: onToggleSeen,
            toggleState: story.seen
        )
    }
}

#Preview {
    VStack {
        GenericProductCard(
            item: "Preview" as String,
            imageURL: "https://placehold.co/600x400",
            title: "Product Title",
            category: "Category",
            price: 99.99,
            onTap: {},
            actionButton: { AnyView(Image(systemName: "star.fill").foregroundColor(.yellow)) }
        )
        .padding()
    }
} 
