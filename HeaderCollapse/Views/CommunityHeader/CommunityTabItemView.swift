//
//  CommunityTabItemView.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 24/05/25.
//

import SwiftUI

/// A reusable view that displays a single tab item for a community with selection animation.
struct CommunityTabItemView: View {

    // MARK: - Properties

    /// The community represented by this tab.
    let community: Community

    /// The currently selected community (bound).
    @Binding var selectedCommunity: Community

    /// Color used for the underline indicator when the tab is active.
    let activeHighlightColor: Color

    /// Shared namespace for matched geometry effect (used for animation).
    let animationNamespace: Namespace.ID

    /// Callback triggered when the tab is selected.
    let onSelect: (Community) -> Void

    // MARK: - Computed Properties

    /// Indicates whether this tab is the active/selected one.
    private var isActive: Bool {
        selectedCommunity.id == community.id
    }

    // MARK: - Initializer

    /// Initializes the community tab item view.
    ///
    /// - Parameters:
    ///   - community: The community to display.
    ///   - selectedCommunity: A binding to the currently selected community.
    ///   - activeHighlightColor: The color of the active underline. Defaults to `.purple`.
    ///   - animationNamespace: A matched geometry namespace for animating transitions.
    ///   - onSelect: A closure executed when this tab is selected.
    init(
        community: Community,
        selectedCommunity: Binding<Community>,
        activeHighlightColor: Color = .purple,
        animationNamespace: Namespace.ID,
        onSelect: @escaping (Community) -> Void = { _ in }
    ) {
        self.community = community
        self._selectedCommunity = selectedCommunity
        self.activeHighlightColor = activeHighlightColor
        self.animationNamespace = animationNamespace
        self.onSelect = onSelect
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            communityNameText
            Spacer()
        }
        .frame(height: 24)
        .overlay(alignment: .bottom) {
            activeUnderline
        }
        .contentShape(.rect) // Ensures full tappable area
        .onTapGesture(perform: handleSelection)
    }

    // MARK: - Subviews

    /// The text view displaying the community name.
    private var communityNameText: some View {
        Text(community.name.capitalized)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(isActive ? .white : .gray)
    }

    /// The underline that appears when the tab is selected.
    @ViewBuilder
    private var activeUnderline: some View {
        if isActive {
            activeHighlightColor
                .frame(height: 3)
                .clipShape(.capsule)
                .matchedGeometryEffect(id: "ACTIVE_COMMUNITY_TAB", in: animationNamespace)
        }
    }

    // MARK: - Actions

    /// Handles the selection of the tab.
    private func handleSelection() {
        guard !isActive else { return }
        withAnimation(.snappy) {
            selectedCommunity = community
            onSelect(community)
        }
    }
}

// MARK: - Preview

#Preview {
    struct CommunityTabItemPreview: View {
        @State private var selectedCommunity: Community = .init(id: 0, name: "gaming")
        @Namespace private var animation

        var body: some View {
            CommunityTabItemView(
                community: .init(id: 0, name: "gaming"),
                selectedCommunity: $selectedCommunity,
                activeHighlightColor: .purple,
                animationNamespace: animation
            ) { selected in
                print("Selected community:", selected)
            }
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
        }
    }

    return CommunityTabItemPreview()
}
