import Foundation
import Observation

@Observable
@MainActor
public final class MarketProductsViewModel: BaseViewModel {
    struct State {
        var products: [ProductDTO] = []
        var isLoading = true
        var isLoadingMore = false
        var errorMessage: String?
        var categoryName: String?
        var currentPage: Page = .default
        var hasMorePages = true
    }
    
    private(set) var state: State = State()
    private let service: PlatziService
    private let categoryID: Int?
    
    init(service: PlatziService, categoryID: Int?) {
        self.service = service
        self.categoryID = categoryID
    }
    
    func fetchProducts(reset: Bool = false) {
        if reset {
            state.products = []
            state.currentPage = .default
            state.isLoading = true
            state.hasMorePages = true
        } else {
            state.isLoadingMore = true
        }
        
        state.errorMessage = nil
        
        Task {
            do {
                let newProducts = try await service.products(categoryID, state.currentPage)
                
                if reset {
                    state.products = newProducts
                } else {
                    state.products.append(contentsOf: newProducts)
                }
                
                if state.currentPage.offset == 0 {
                    state.categoryName = state.products.first?.category.name
                }
                
                state.hasMorePages = newProducts.count >= state.currentPage.limit
                
                if state.hasMorePages {
                    state.currentPage = state.currentPage.next
                }
                
                state.isLoading = false
                state.isLoadingMore = false
            } catch {
                state.errorMessage = "Failed to load products"
                state.isLoading = false
                state.isLoadingMore = false
                handleError(error)
            }
        }
    }
    
    func loadMoreProducts() {
        if !state.isLoadingMore && state.hasMorePages {
            fetchProducts(reset: false)
        }
    }
    
    func refreshProducts() async {
//        await withCheckedContinuation { continuation in
//            fetchProducts(reset: true)
//            continuation.resume()
//        }
        fetchProducts(reset: true)
    }
} 
