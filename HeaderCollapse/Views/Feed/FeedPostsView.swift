//
//  FeedPostsView.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 24/05/25.
//


import SwiftUI

/// A scrollable list of placeholder feed posts with randomized background colors.
/// This view demonstrates a simple feed layout using `RoundedRectangle` views.
struct FeedPostsView: View {
    
    // MARK: - Body
    
    var body: some View {
            VStack(spacing: 16) {
                ForEach(1...48, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.random())
                        .frame(height: 84)
                }
            }
            .padding(.horizontal, 16)
    }
}

// MARK: - Preview

#Preview {
    FeedPostsView()
        .preferredColorScheme(.light)
}

private extension Color {

    static func random(randomOpacity: Bool = false) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: randomOpacity ? .random(in: 0...1) : 1
        )
    }
}

