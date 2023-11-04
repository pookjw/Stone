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
        
        #expect(!response.sets.isEmpty)
        #expect(!response.setGroups.isEmpty)
        #expect(!response.gameModes.isEmpty)
        #expect(!response.arenaIds.isEmpty)
        #expect(!response.types.isEmpty)
        #expect(!response.rarities.isEmpty)
        #expect(!response.classes.isEmpty)
        #expect(!response.minionTypes.isEmpty)
        #expect(!response.spellSchools.isEmpty)
        #expect(!response.mercenaryRoles.isEmpty)
        #expect(!response.mercenaryFactions.isEmpty)
        #expect(!response.keywords.isEmpty)
        #expect(!response.filterableFields.isEmpty)
        #expect(!response.numericFields.isEmpty)
        #expect(!response.cardBackCategories.isEmpty)
    }
}
