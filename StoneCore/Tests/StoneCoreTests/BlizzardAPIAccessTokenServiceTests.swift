import Foundation
import Testing
@testable @_private(sourceFile: "CoreDataStack.swift") import StoneCore
@testable @_private(sourceFile: "BlizzardAPIAccessTokenService.swift") import StoneCore

actor BlizzardAPIAccessTokenServiceTests {
    private let blizzardAPIAccessTokenService: BlizzardAPIAccessTokenService = .shared
    
    init() async throws {
        try await blizzardAPIAccessTokenService.coreDataStack.destory()
    }
    
    @Test(.tags(["test_accessToken"])) func test_accessToken() async throws {
        let region: Locale.Region = Locale.current.region ?? .unitedStates
        
        let (cachedAccessToken_1, cachedExpirationDate_1, fetchedObjects_1): (String?, Date?, [BlizzardAPIAccessToken]) = try await blizzardAPIAccessTokenService.fetchAccessTokenCache(region: region)
        
        #expect(cachedAccessToken_1 == nil)
        #expect(cachedExpirationDate_1 == nil)
        #expect(fetchedObjects_1.isEmpty)
        
        let accessToken: String = try await blizzardAPIAccessTokenService.accessToken(region: region)
        let (cachedAccessToken_2, cachedExpirationDate_2, fetchedObjects_2): (String?, Date?, [BlizzardAPIAccessToken]) = try await blizzardAPIAccessTokenService.fetchAccessTokenCache(region: region)
        
        #expect(accessToken == cachedAccessToken_2)
        try #expect(#require(cachedExpirationDate_2) > .now)
        #expect(fetchedObjects_2.count == 1)
    }
}
