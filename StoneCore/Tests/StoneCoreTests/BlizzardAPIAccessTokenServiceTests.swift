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
        
        let cache_1: (String, Date)? = try await blizzardAPIAccessTokenService.fetchAccessTokenCache(region: region)
        
        #expect(cache_1 == nil)
        
        let accessToken: String = try await blizzardAPIAccessTokenService.accessToken(region: region)
        let cache_2: (String, Date)? = try await blizzardAPIAccessTokenService.fetchAccessTokenCache(region: region)
        
        #expect(accessToken == cache_2?.0)
        try #expect(#require(cache_2?.1) > .now)
    }
}
