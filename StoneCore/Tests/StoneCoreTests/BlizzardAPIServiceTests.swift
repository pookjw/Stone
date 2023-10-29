import Foundation
import Testing
@testable @_private(sourceFile: "BlizzardAPIService.swift") import StoneCore

actor BlizzardAPIServiceTests {
    private let service: BlizzardAPIService = .init()
    
    init() {
        // setup...
    }
    
    deinit {
        // teardown...
    }
    
    @Test func requestAccessToken() async throws {
        let (accessToken, expirationDate): (String, Date) = try await service.requestAccessToken()
        
        #expect(!accessToken.isEmpty)
        #expect(expirationDate > .now)
    }
}
