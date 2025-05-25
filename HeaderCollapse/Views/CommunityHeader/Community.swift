//
//  Community.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 25/05/25.
//


import SwiftUI

// MARK: - Model

/// Represents a community entity.
struct Community: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
}

/// Response model for paginated community data.
struct CommunityResponse: Decodable {
    let pageNumber: Int
    let pageSize: Int
    let totalRecordCount: Int
    let nextPage: String?
    let records: [Community]

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_number"
        case pageSize = "page_size"
        case totalRecordCount = "total_record_count"
        case nextPage = "next_page"
        case records
    }
}


// MARK: - ViewModel

/// ViewModel responsible for managing community data.
@MainActor
final class CommunityViewModel: ObservableObject {
    @Published var communities: [Community] = []
    @Published var isLoading: Bool = false
    @Published var selectedCommunity: Community?

    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    private let communityService: CommunityServiceProtocol

    /// Initializes the view model with a community service.
    init(communityService: CommunityServiceProtocol = CommunityService()) {
        self.communityService = communityService
    }

    /// Loads the first page of community data.
    func loadInitialData() async {
        guard !isLoading else { return }
        isLoading = true

        do {
            let response = try await communityService.fetchLocalCommunities(page: currentPage)
            communities = response.records
            selectedCommunity = response.records.first
            currentPage += 1
            canLoadMore = response.nextPage != nil
        } catch {
            print("Initial load error: \(error.localizedDescription)")
        }

        isLoading = false
    }

    /// Loads more data if the current item is near the end of the list.
    func loadMoreIfNeeded(currentItem: Community) async {
        guard !isLoading, canLoadMore else { return }

        let thresholdIndex = max(communities.count - 5, 0)
        if let currentIndex = communities.firstIndex(where: { $0.id == currentItem.id }), currentIndex >= thresholdIndex {
            await loadMoreData()
        }
    }

    /// Loads the next page of community data.
    private func loadMoreData() async {
        isLoading = true

        do {
            let response = try await communityService.fetchLocalCommunities(page: currentPage)
            communities.append(contentsOf: response.records)
            currentPage += 1
            canLoadMore = response.nextPage != nil
        } catch {
            print("Load more error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
