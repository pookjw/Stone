import Foundation
import Testing
@testable import StoneCore

actor HearthstoneAPIServiceTests {
    private let service: HearthstoneAPIService = .init()
    
    @Test func metadata() async throws {
        let response: HSMetadataResponse = try await service.metadata()
        let _: HSMetadataResponse = try await service.metadata()
        
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
