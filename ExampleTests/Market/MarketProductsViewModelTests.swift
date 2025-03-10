import Testing
import Foundation
@testable import Example

@MainActor
@Suite("MarketProductsViewModel Tests")
struct MarketProductsViewModelTests {
    @Test("Initial state should be correct")
    func testInitialState() {
        let sut = MarketProductsViewModel(service: .mock, categoryID: nil)
        
        #expect(sut.state.products.isEmpty)
        #expect(sut.state.isLoading == true)
        #expect(sut.state.isLoadingMore == false)
        #expect(sut.state.errorMessage == nil)
        #expect(sut.state.categoryName == nil)
        #expect(sut.state.currentPage == .default)
        #expect(sut.state.hasMorePages == true)
    }
    
    @Test("fetchProducts should update state correctly on success")
    func testFetchProductsSuccess() async throws {
        // Given
        let mockProducts = [ProductDTO.mock]
        let mockService = PlatziService.mock
        let sut = MarketProductsViewModel(service: mockService, categoryID: nil)
        
        // When
        await sut.fetchProducts(reset: true)
        
        // Then
        #expect(sut.state.products == mockProducts)
        #expect(sut.state.isLoading == false)
        #expect(sut.state.isLoadingMore == false)
        #expect(sut.state.errorMessage == nil)
        #expect(sut.state.categoryName == mockProducts.first?.category.name)
        #expect(sut.state.hasMorePages == false) // because count < limit
    }
    
    @Test("fetchProducts should handle errors correctly")
    func testFetchProductsError() async throws {
        // Given
        struct TestError: Error {}
        let mockService = PlatziService(
            categories: { [] },
            products: { _, _ in throw TestError() },
            product: { _ in .mock }
        )
        let sut = MarketProductsViewModel(service: mockService, categoryID: nil)
        
        // When
        await sut.fetchProducts(reset: true)
        
        // Then
        #expect(sut.state.products.isEmpty)
        #expect(sut.state.isLoading == false)
        #expect(sut.state.isLoadingMore == false)
        #expect(sut.state.errorMessage == "Failed to load products")
    }
    
    @Test("loadMoreProducts should append products correctly")
    func testLoadMoreProducts() async throws {
        // Given
        let initialProducts = [ProductDTO.mock]
        let additionalProducts = [ProductDTO(id: 2, title: "iPad", description: "Apple", price: 800, category: .mock, images: [])]
        var isFirstCall = true
        
        let mockService = PlatziService(
            categories: { [] },
            products: { _, _ in
                if isFirstCall {
                    isFirstCall = false
                    return initialProducts
                }
                return additionalProducts
            },
            product: { _ in .mock }
        )
        
        let sut = MarketProductsViewModel(service: mockService, categoryID: nil)
        
        // When
        await sut.fetchProducts(reset: true) // Load initial products
        await sut.loadMoreProducts() // Load more products
        
        // Then
        #expect(sut.state.products.count == 2)
        #expect(sut.state.products.contains(initialProducts[0]))
        #expect(sut.state.products.contains(additionalProducts[0]))
    }
    
    @Test("refreshProducts should reset and fetch new products")
    func testRefreshProducts() async throws {
        // Given
        let initialProducts = [ProductDTO.mock]
        let refreshedProducts = [ProductDTO(id: 2, title: "iPad", description: "Apple", price: 800, category: .mock, images: [])]
        var isFirstCall = true
        
        let mockService = PlatziService(
            categories: { [] },
            products: { _, _ in
                if isFirstCall {
                    isFirstCall = false
                    return initialProducts
                }
                return refreshedProducts
            },
            product: { _ in .mock }
        )
        
        let sut = MarketProductsViewModel(service: mockService, categoryID: nil)
        
        // When
        await sut.fetchProducts(reset: true) // Initial load
        #expect(sut.state.products == initialProducts)
        
        await sut.refreshProducts() // Refresh
        
        // Then
        #expect(sut.state.products == refreshedProducts)
        #expect(sut.state.currentPage == .default)
    }
} 
