//
//  CommunityServiceProtocol.swift
//  HeaderCollapse
//
//  Created by Swarajmeet Singh on 25/05/25.
//


import Foundation

// MARK: - Service Protocol

/// Protocol defining community data fetching service.
protocol CommunityServiceProtocol {
    func fetchLocalCommunities(page: Int) async throws -> CommunityResponse
}

// MARK: - Service Implementation

/// Handles API requests to fetch community data.
final class CommunityService: CommunityServiceProtocol {
    
    func fetchLocalCommunities(page: Int) async throws -> CommunityResponse {
        let fileName = "community-page-\(page)" // Ensure file is named like community-page-1.json
        print("📄 [Local Load] Fetching communities from local file: \(fileName).json")
        try await Task.sleep(nanoseconds: 3_000_000_000)
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(
                domain: "LocalFileError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "File \(fileName).json not found in bundle"]
            )
        }

        let data = try Data(contentsOf: url)

        // Pretty-print JSON response
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("📦 [Local JSON - Page \(page)]:\n\(prettyString)")
        } else {
            print("⚠️ [Logger Warning] Unable to pretty print local JSON data.")
        }

        // Decode and return with do-catch
        do {
            let decoded = try JSONDecoder().decode(CommunityResponse.self, from: data)
            print("✅ [Decoding] Successfully decoded CommunityResponse for page \(page)")
            return decoded
        } catch {
            print("❌ [Decoding Error] Failed to decode CommunityResponse: \(error.localizedDescription)")
            throw error
        }
    }

}
