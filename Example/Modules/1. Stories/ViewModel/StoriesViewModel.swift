//
//  StoriesViewModel.swift
//  Example
//
//  Created by Ara Hakobyan on 3/11/25.
//

import Foundation
import Observation
import SwiftData

@Observable
@MainActor
public final class StoriesViewModel: BaseViewModel {
    struct State {
        var stories: [Story] = []
        var isLoading = true
        var isLoadingMore = false
        var errorMessage: String?
        var currentPage: Page = .default
        var hasMorePages = true
    }
    
    private(set) var state: State = State()
    private let service: PlatziService
    
    init(service: PlatziService) {
        self.service = service
    }
    
    func fetch(reset: Bool = false) {
        if reset {
            state.stories = []
            state.currentPage = .default
            state.isLoading = true
            state.hasMorePages = true
        } else {
            state.isLoadingMore = true
        }
        
        state.errorMessage = nil
        
        Task {
            do {
                let new = try await service.products(nil, state.currentPage).map { Story(id: $0.id, seen: false, product: $0) }
                
                if reset {
                    state.stories = new
                } else {
                    state.stories.append(contentsOf: new)
                }
                
                state.hasMorePages = new.count >= state.currentPage.limit
                
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
            fetch(reset: false)
        }
    }
    
    func refresh() async {
        await withCheckedContinuation { continuation in
            fetch(reset: true)
            continuation.resume()
        }
    }
    
    // Mark a story as seen
    func markAsSeen(_ storyId: Int) {
        if let index = state.stories.firstIndex(where: { $0.id == storyId }) {
            state.stories[index].seen = true
        }
    }
    
    // Mark a story as unseen
    func markAsUnseen(_ storyId: Int) {
        if let index = state.stories.firstIndex(where: { $0.id == storyId }) {
            state.stories[index].seen = false
        }
    }
    
    // Toggle the seen status of a story
    func toggleSeenStatus(_ storyId: Int) {
        if let index = state.stories.firstIndex(where: { $0.id == storyId }) {
            state.stories[index].seen.toggle()
        }
    }
}
