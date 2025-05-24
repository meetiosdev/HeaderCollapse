//
//  ResizableHeaderScrollView.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 24/05/25.
//

import SwiftUI

/// A generic scroll view that includes a resizable header and sticky subheader.
/// - Customizable with header, stickyHeader, background, and content.
/// - Implements drag gestures to shrink/expand the header dynamically.
struct ResizableHeaderScrollView<Header: View, StickyHeader: View, Background: View, Content: View>: View {

    // MARK: - Input Views

    var spacing: CGFloat = 20
    @ViewBuilder var header: Header
    @ViewBuilder var stickyHeader: StickyHeader
    @ViewBuilder var background: Background // Used only for the header's background, not the whole scroll view
    @ViewBuilder var content: Content

    // MARK: - State Properties

    @State private var currentDragOffset: CGFloat = 0
    @State private var previousDragOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var headerSize: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0

    // MARK: - Body

    var body: some View {
        ScrollView(.vertical) {
            content
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
        
        // Track scroll offset using custom geometry reader extension
        .onScrollGeometryChange(for: CGFloat.self, of: {
            $0.contentOffset.y + $0.contentInsets.top
        }, action: { _, newValue in
            scrollOffset = newValue
        })

        // Apply drag gesture to dynamically adjust header offset
        .simultaneousGesture(
            DragGesture(minimumDistance: 10)
                .onChanged { value in
                    let dragOffset = -max(0, abs(value.translation.height) - 50) *
                        (value.translation.height < 0 ? -1 : 1)

                    previousDragOffset = currentDragOffset
                    currentDragOffset = dragOffset

                    let deltaOffset = currentDragOffset - previousDragOffset

                    // Clamp the headerOffset between 0 and headerSize
                    headerOffset = max(min(headerOffset + deltaOffset, headerSize), 0)
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if headerOffset > (headerSize * 0.5) && scrollOffset > headerSize {
                            headerOffset = headerSize // Collapse fully
                        } else {
                            headerOffset = 0 // Expand fully
                        }
                    }

                    // Reset drag values
                    currentDragOffset = 0
                    previousDragOffset = 0
                }
        )

        // Inject header at top with safe area inset
        .safeAreaInset(edge: .top, spacing: spacing) {
            buildCombinedHeader()
        }
    }

    // MARK: - Combined Header Builder

    @ViewBuilder
    private func buildCombinedHeader() -> some View {
        VStack(spacing: spacing) {
            header
                .onGeometryChange(for: CGFloat.self) {
                    $0.size.height
                } action: { newValue in
                    // Update header size including spacing buffer
                    headerSize = newValue + spacing
                }

            stickyHeader
        }
        .offset(y: -headerOffset)
        .clipped()
        .background {
            background
                .ignoresSafeArea()
                .offset(y: -headerOffset)
        }
    }
}

#Preview {
    ResizableHeaderScrollView(
        spacing: 20,
        header: {
            // Example Header View
            VStack {
                Text("Header")
                    .font(.largeTitle.bold())
                    .padding()
                Divider()
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.3))
        },
        stickyHeader: {
            // Example Sticky Header (e.g. tab bar)
            HStack {
                Text("Tab 1")
                Spacer()
                Text("Tab 2")
            }
            .padding()
            .background(Color.gray.opacity(0.2))
        },
        background: {
            // Background for the header area
            Rectangle()
                .fill(Color.white)
                .shadow(radius: 2)
        },
        content: {
            // Sample Content List
            VStack(spacing: 16) {
                ForEach(0..<20, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.yellow)
                        .frame(height: 80)
                        .overlay(Text("Item \(index)").foregroundColor(.white))
                }
            }
            .padding()
        }
    )
}
