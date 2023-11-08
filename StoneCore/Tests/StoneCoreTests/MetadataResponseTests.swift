import Foundation
import UniformTypeIdentifiers
import Testing
@testable import StoneCore

actor MetadataResponseTests {
    @Test func decode() async throws {
        let url: URL = try #require(Bundle.module.url(forResource: "hs_metadata_response_sample", withExtension: UTType.json.preferredFilenameExtension))
        let data: Data = try .init(contentsOf: url)
        let decoder: JSONDecoder = .init()
        let response: HearthstoneAPIService.MetadataResponse = try decoder.decode(HearthstoneAPIService.MetadataResponse.self, from: data)
        
        try #expect(!#require(response.sets?.isEmpty))
        try #expect(!#require(response.setGroups?.isEmpty))
        try #expect(!#require(response.gameModes?.isEmpty))
        try #expect(!#require(response.arenaIds?.isEmpty))
        try #expect(!#require(response.types?.isEmpty))
        try #expect(!#require(response.rarities?.isEmpty))
        try #expect(!#require(response.classes?.isEmpty))
        try #expect(!#require(response.minionTypes?.isEmpty))
        try #expect(!#require(response.spellSchools?.isEmpty))
        try #expect(!#require(response.mercenaryRoles?.isEmpty))
        try #expect(!#require(response.mercenaryFactions?.isEmpty))
        try #expect(!#require(response.keywords?.isEmpty))
        try #expect(!#require(response.filterableFields?.isEmpty))
        try #expect(!#require(response.numericFields?.isEmpty))
        try #expect(!#require(response.cardBackCategories?.isEmpty))
    }
}
