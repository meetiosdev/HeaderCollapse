//
//  MelpotFeedView.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 24/05/25.
//


import SwiftUI

/// A screen displaying a dynamic feed of community posts with a collapsible header and sticky tab bar.
struct MelpotFeedView: View {

    // MARK: - Body

    var body: some View {
        ResizableHeaderScrollView {
            headerBar
        } stickyHeader: {
            CommunityTabsView()
        } background: {
            headerBackground
        } content: {
            FeedPostsView()
        }
    }

    // MARK: - Header Section

    /// The top header bar with user profile and message actions.
    @ViewBuilder
    private var headerBar: some View {
        FeedNavigationBar {
            print("User avatar tapped – open side menu.")
        } onMessagesTapped: {
            print("Message icon tapped – open messages.")
        }
    }

    /// Background for the header including a material fill and bottom divider.
    @ViewBuilder
    private var headerBackground: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .overlay(alignment: .bottom) {
                Divider()
            }
    }

}

#Preview {
    MelpotFeedView()
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
