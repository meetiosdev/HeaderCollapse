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


// MARK: - CommunityViewModel

/// `CommunityViewModel` manages the loading and pagination of community data.
/// It exposes observable properties to allow SwiftUI views to reactively update.
@MainActor
final class CommunityViewModel: ObservableObject {

    // MARK: - Published Properties

    /// The list of communities fetched from the service.
    @Published private(set) var communities: [Community] = []

    /// Indicates whether the view model is currently loading data.
    @Published private(set) var isLoading: Bool = false

    /// The currently selected community.
    @Published var selectedCommunity: Community?

    // MARK: - Private Properties

    private var currentPage: Int = 1
    private var canLoadMorePages: Bool = true
    private let service: CommunityServiceProtocol

    // MARK: - Initialization

    /// Initializes the view model with an injected community service.
    /// - Parameter service: A type conforming to `CommunityServiceProtocol`. Defaults to `CommunityService()`.
    init(service: CommunityServiceProtocol = CommunityService()) {
        self.service = service
    }

    // MARK: - Data Loading

    /// Loads the initial set of communities (first page).
    func loadInitialData() async {
        await loadCommunities(reset: true)
    }

    /// Triggers loading of more data if the current item is near the end of the list.
    /// - Parameter item: The currently visible community triggering this check.
    func loadMoreIfNeeded(near item: Community) async {
        guard !isLoading, canLoadMorePages else { return }

        let preloadThreshold = 5
        if let index = communities.firstIndex(of: item),
           index >= communities.count - preloadThreshold {
            await loadCommunities(reset: false)
        }
    }

    // MARK: - Core Loading Logic

    /// Loads communities from the service, either from the first page or appending more.
    /// - Parameter reset: Set `true` to reset the list and start from page 1.
    private func loadCommunities(reset: Bool) async {
        guard !isLoading else { return }
        isLoading = true

        do {
            if reset {
                currentPage = 1
                canLoadMorePages = true
            }

            let response = try await service.fetchLocalCommunities(page: currentPage)

            if reset {
                communities = response.records
                selectedCommunity = response.records.first
            } else {
                communities.append(contentsOf: response.records)
            }

            currentPage += 1
            canLoadMorePages = (response.nextPage != nil)

        } catch {
            print("❌ Failed to load communities: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
