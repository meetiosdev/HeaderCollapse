//
//  CommunityTabsView.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 24/05/25.
//


import SwiftUI

// MARK: - CommunityTabsView

/// A reusable, scrollable tab bar for community selection.
struct CommunityTabsView: View {

    // MARK: - Properties

    private let communities: [String] = [
        "AskReddit", "worldnews", "funny", "gaming", "aww", "pics", "science", "todayilearned",
        "movies", "news", "Showerthoughts", "askscience", "IAmA", "technology", "LifeProTips",
        "DIY", "space", "nottheonion", "Documentaries", "books", "food", "Art", "dataisbeautiful",
        "gadgets", "Fitness", "history", "photoshopbattles", "Futurology", "explainlikeimfive",
        "sports", "television", "WritingPrompts", "personalfinance", "nosleep", "philosophy",
        "InternetIsBeautiful", "GetMotivated", "UpliftingNews", "Music", "Jokes", "OldSchoolCool",
        "Anime", "travel", "spaceporn", "cringe", "wholesomememes", "memes", "interestingasfuck",
        "TIFU", "relationship advice"
    ]

    @State private var selectedCommunity: String = "AskReddit"
    @Namespace private var animation

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 24) {
                ForEach(communities, id: \.self) { community in
                    CommunityTabItemView(
                        name: community,
                        selectedCommunity: $selectedCommunity,
                        animationNamespace: animation
                    ) { selected in
                        print("Selected community: \(selected)")
                    }
                }
            }
        }
        .contentMargins(.horizontal, 16)
        .scrollIndicators(.hidden)
        .scrollPosition(id: .init(get: {
            return selectedCommunity
        }, set: { _ in
            
        }), anchor: .center)
    }
}

// MARK: - Preview

#Preview {
    CommunityTabsView()
        .background(Color.black)
        .preferredColorScheme(.dark)
    
}
