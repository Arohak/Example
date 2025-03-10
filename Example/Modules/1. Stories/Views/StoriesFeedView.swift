//
//  StoriesFeedView.swift
//  Example
//
//  Created by Ara Hakobyan on 3/11/25.
//


import SwiftUI
import SwiftData

public struct StoriesFeedView: View {
    private let navigator: Navigator<StoriesScreen>
    
    @State private var viewModel: StoriesViewModel

    public init(navigator: Navigator<StoriesScreen>, service: PlatziService) {
        self.navigator = navigator
        _viewModel = State(initialValue: .init(service: service))
    }
    
    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.stories.isEmpty {
                LoadingView()
            } else if let error = viewModel.state.errorMessage, viewModel.state.stories.isEmpty {
                ContentUnavailableView {
                    Label("Failed to Load", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error)
                } actions: {
                    Button("Try Again") {
                        viewModel.fetch(reset: true)
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 16)
                        ],
                        spacing: 16
                    ) {
                        ForEach(viewModel.state.stories) { story in
                            StoryCard(story: story)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        navigator.push(.item(story.id))
                                    }
                                }
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        if !viewModel.state.stories.isEmpty {
                            Group {
                                if viewModel.state.isLoadingMore {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                } else if viewModel.state.hasMorePages {
                                    Color.clear
                                        .frame(height: 50)
                                        .onAppear {
                                            viewModel.loadMoreProducts()
                                        }
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding()
                }
                .refreshable {
//                    await viewModel.refresh()
//                    viewModel.fetch(reset: true)
                }
                .overlay {
                    if viewModel.state.stories.isEmpty {
                        ContentUnavailableView {
                            Label("No Stories", systemImage: "cart.badge.questionmark")
                        } description: {
                            Text("Try refreshing to see available stories")
                        }
                    }
                }
            }
        }
        .navigationTitle("Stories")
        .animation(.spring(response: 0.3), value: viewModel.state.stories)
        .task {
            if viewModel.state.stories.isEmpty {
                viewModel.fetch(reset: true)
            }
        }
    }
}

#Preview {
    NavigationView {
        StoriesFeedView(navigator: .init(), service: .mock)
    }
}
