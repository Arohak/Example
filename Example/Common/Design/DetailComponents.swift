//
//  DetailComponents.swift
//  Example
//
//  Created by Claude AI on 3/15/25.
//

import SwiftUI

// MARK: - Image Gallery

public struct ImageGallery: View {
    let images: [String]
    
    @State private var selectedIndex = 0
    
    public init(images: [String]) {
        self.images = images
    }
    
    public var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<images.count, id: \.self) { index in
                AsyncImageView(
                    urlString: images[index],
                    height: 300,
                    contentMode: .fit
                )
                .tag(index)
            }
        }
        .frame(height: 300)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

// MARK: - Section Header

public struct SectionHeader: View {
    let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top, 8)
    }
}

// MARK: - Product Info Section

public struct ProductInfoSection: View {
    let title: String
    let category: String
    let price: Double
    let categoryColor: Color
    
    public init(title: String, category: String, price: Double, categoryColor: Color = .orange) {
        self.title = title
        self.category = category
        self.price = price
        self.categoryColor = categoryColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Category badge
            Text(category)
                .badgeStyle(color: categoryColor)
            
            // Title
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            
            // Price
            Text("$\(String(format: "%.2f", price))")
                .priceStyle()
        }
    }
}

// MARK: - Action Button

public struct ActionButton: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let action: () -> Void
    
    public init(title: String, icon: String, backgroundColor: Color = .blue, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .actionButtonStyle(backgroundColor: backgroundColor)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        ImageGallery(images: [
            "https://placehold.co/600x400/blue/white",
            "https://placehold.co/600x400/red/white",
            "https://placehold.co/600x400/green/white"
        ])
        
        ProductInfoSection(
            title: "Premium Product",
            category: "Electronics",
            price: 299.99,
            categoryColor: .orange
        )
        .padding(.horizontal)
        
        SectionHeader(title: "Description")
            .padding(.horizontal)
        
        Text("This is a detailed description of the product with all its features and specifications.")
            .foregroundStyle(.secondary)
            .padding(.horizontal)
        
        HStack {
            Spacer()
            ActionButton(
                title: "Add to Cart",
                icon: "cart.badge.plus",
                backgroundColor: .blue
            ) {
                print("Add to cart tapped")
            }
            Spacer()
        }
        .padding()
    }
} 