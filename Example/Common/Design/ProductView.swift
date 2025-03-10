//
//  ProductView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/10/25.
//

import SwiftUI

public struct ProductView: View {
    let product: ProductDTO
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let thumbnail = product.thumbnail {
                AsyncImage(url: URL(string: thumbnail)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure(_):
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // Category badge
            Text(product.category.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            // Title
            Text(product.title)
                .font(.title)
                .fontWeight(.bold)
            
            // Price
            HStack {
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
                
                Spacer()
                
                Button(action: {
                    // Add to cart functionality
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Add to Cart")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            // Description header
            Text("Description")
                .font(.headline)
                .padding(.top, 8)
            
            // Description
            Text(product.description)
                .font(.body)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
    }
}
