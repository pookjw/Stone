import Foundation
import UniformTypeIdentifiers
import Testing
@testable import StoneCore

actor CardBacksResponseTests {
    @Test func decode() async throws {
        let url: URL = try #require(Bundle.module.url(forResource: "hs_card_backs_response_sample", withExtension: UTType.json.preferredFilenameExtension))
        let data: Data = try .init(contentsOf: url)
        let decoder: JSONDecoder = .init()
        let response: HearthstoneAPIService.CardBacksResponse = try decoder.decode(HearthstoneAPIService.CardBacksResponse.self, from: data)
    }
}
