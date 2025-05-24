//
//  CommunityTabItemView.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 24/05/25.
//


import SwiftUI

/// A reusable view representing a single community tab item with animated selection.
struct CommunityTabItemView: View {

    // MARK: - Public Properties

    let name: String
    @Binding var selectedCommunity: String
    let activeHighlightColor: Color
    let animationNamespace: Namespace.ID
    let onSelect: (String) -> Void

    // MARK: - Private Computed Properties

    private var isActive: Bool {
        selectedCommunity == name
    }

    // MARK: - Init with Defaults

    /// Initializes a new `CommunityTabItemView`.
    /// - Parameters:
    ///   - name: The name of the community.
    ///   - selectedCommunity: A binding to the selected community name.
    ///   - activeHighlightColor: The color used to indicate the selected tab. Defaults to `.purple`.
    ///   - animationNamespace: The matched geometry animation namespace.
    ///   - onSelect: A callback triggered when the tab is selected. Defaults to a no-op.
    init(
        name: String,
        selectedCommunity: Binding<String>,
        activeHighlightColor: Color = .purple,
        animationNamespace: Namespace.ID,
        onSelect: @escaping (String) -> Void = { _ in }
    ) {
        self.name = name
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
        .contentShape(.rect)
        .onTapGesture(perform: handleSelection)
    }

    // MARK: - Subviews

    private var communityNameText: some View {
        Text(name.capitalized)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(isActive ? .white : .gray)
    }

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

    private func handleSelection() {
        guard selectedCommunity != name else { return }
        withAnimation(.snappy) {
            selectedCommunity = name
            onSelect(name)
        }
    }
}

#Preview {
    struct CommunityTabItemPreview: View {
        @State private var selectedCommunity = "gaming"
        @Namespace private var animation

        var body: some View {
            CommunityTabItemView(
                name: "gaming",
                selectedCommunity: $selectedCommunity,
                activeHighlightColor: .blue,
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
