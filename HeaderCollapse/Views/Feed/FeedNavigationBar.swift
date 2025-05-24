//
//  FeedNavigationBar.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 24/05/25.
//

import SwiftUI
// MARK: - FeedNavigationBar

/// A reusable top navigation bar with user avatar, app logo, and message icon.
struct FeedNavigationBar: View {

    // MARK: - Callbacks

    let onUserTapped: () -> Void
    let onMessagesTapped: () -> Void

    // MARK: - Body

    var body: some View {
        HStack {
            Button(action: onUserTapped) {
                Image(.imageUser)
                    .resizable()
                    .clipShape(.circle)
                    .frame(width: 32, height: 32)
            }

            Spacer()

            Button(action: onMessagesTapped) {
                Image(.iconMessageBox)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .overlay {
            Image(.logoLarge)
                .resizable()
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    FeedNavigationBar(
        onUserTapped: {
            print("User avatar tapped")
        },
        onMessagesTapped: {
            print("Messages icon tapped")
        }
    )
    .previewLayout(.sizeThatFits)
    .padding()
    .background(Color(.systemBackground))
}
