//
//  CommunityTabsView.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 24/05/25.
//


import SwiftUI

// MARK: - CommunityTabsView

/// A horizontally scrollable, animated tab bar for selecting communities.
///
/// This view fetches community data via `CommunityViewModel` and renders each as an interactive tab item.
/// It handles infinite scrolling and scroll-to-selected behavior.
struct CommunityTabsView: View {

    // MARK: - State & Dependencies

    @StateObject private var viewModel = CommunityViewModel()
    @Namespace private var animation

    // MARK: - Body

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 24) {
                    ForEach(viewModel.communities, id: \ .id) { community in
                        CommunityTabItemView(
                            community: community,
                            selectedCommunity: selectedCommunityBinding(for: community),
                            animationNamespace: animation
                        ) { selected in
                            print("Switched to:", selected.name)
                        }
                        .id(community.id) // Enables scroll-to-selected
                        .onAppear {
                            Task {
                                await viewModel.loadMoreIfNeeded(currentItem: community)
                            }
                        }
                    }

                    if viewModel.isLoading && !viewModel.communities.isEmpty {
                        ProgressView()
                            .frame(height: 24)
                            .padding(.trailing)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 24)
            .onChange(of: viewModel.selectedCommunity) { oldValue, community in
                guard let community = community else { return }
                withAnimation {
                    scrollProxy.scrollTo(community.id, anchor: .center)
                }
            }
            .task {
                await viewModel.loadInitialData()
            }
        }
    }

    // MARK: - Private Helpers

    /// Provides a binding to the selected community, force-unwrapped for compatibility with tab items.
    private func selectedCommunityBinding(for community: Community) -> Binding<Community> {
        Binding(
            get: { viewModel.selectedCommunity ?? community },
            set: { viewModel.selectedCommunity = $0 }
        )
    }
}

// MARK: - Preview

#Preview {
    CommunityTabsView()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
