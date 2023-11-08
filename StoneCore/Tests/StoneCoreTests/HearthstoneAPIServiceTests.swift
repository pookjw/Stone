import Foundation
import Testing
@testable import StoneCore

actor HearthstoneAPIServiceTests {
    private let service: HearthstoneAPIService = .init()
    
    @Test func metadata() async throws {
        let response: HearthstoneAPIService.MetadataResponse = try await service.metadata()
        
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
    
    @Test func cardBacks() async throws {
        let response: HearthstoneAPIService.CardBacksResponse = try await service
            .cardBacks()
        
        #expect(!response.cardBacks.isEmpty)
    }
}
