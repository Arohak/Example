import SwiftUI

struct ProductCard: View {
    let product: ProductDTO

    @State private var isImageLoaded = false
    
    var body: some View {
        VStack {
            // Image section
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onAppear { isImageLoaded = true }
                case .failure:
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 8) {
                // Category badge
                Text(product.category.name)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
                
                // Title and description
                Group {
                    Text(product.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(product.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .opacity(isImageLoaded ? 1 : 0)
                
                // Price
                Text("$\(String(format: "%.2f", product.price))")
                    .font(.title3.bold())
                    .foregroundStyle(.blue)
            }
            .padding()
        }
        .cardStyle()
        .animation(.spring(response: 0.3), value: isImageLoaded)
    }
} 
