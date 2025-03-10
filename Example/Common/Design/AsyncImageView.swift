//
//  AsyncImageView.swift
//  Example
//
//  Created by Claude AI on 3/15/25.
//

import SwiftUI

public struct AsyncImageView: View {
    let url: URL?
    var height: CGFloat? = 200
    var contentMode: ContentMode = .fill
    var onImageLoaded: (() -> Void)? = nil
    
    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .onAppear {
                        onImageLoaded?()
                    }
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.secondary)
                    .padding()
                    .onAppear {
                        onImageLoaded?()
                    }
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
        .asyncImageStyle(height: height, contentMode: contentMode)
    }
}

extension AsyncImageView {
    public init(urlString: String?, height: CGFloat? = 200, contentMode: ContentMode = .fill, onImageLoaded: (() -> Void)? = nil) {
        self.url = urlString.flatMap { URL(string: $0) }
        self.height = height
        self.contentMode = contentMode
        self.onImageLoaded = onImageLoaded
    }
}

#Preview {
    VStack(spacing: 20) {
        AsyncImageView(urlString: "https://placehold.co/600x400")
        
        AsyncImageView(urlString: "invalid-url")
        
        AsyncImageView(urlString: nil)
    }
    .padding()
} 