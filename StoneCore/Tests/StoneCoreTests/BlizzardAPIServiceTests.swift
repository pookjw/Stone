import Foundation
import Testing
@testable @_private(sourceFile: "BlizzardAPIService.swift") import StoneCore

actor BlizzardAPIServiceTests {
    private let service: BlizzardAPIService = .init()
    
    init() async {
        await clearValues()
    }
    
    @Test func accessToken() async throws {
        let accessToken_1: String = try await service.accessToken
        let accessToken_2: String = try await service.accessToken
        print(accessToken_1)
        
        #expect(accessToken_1 == accessToken_2)
    }
    
    @Test func requestAccessToken() async throws {
        let (accessToken, expirationDate): (String, Date) = try await service.requestAccessToken()
        
        #expect(!accessToken.isEmpty)
        #expect(expirationDate > .now)
    }
    
    private func clearValues() async {
        let userDefaults: UserDefaults = await service.userDefaults
        await userDefaults.removeObject(forKey: service.accessTokenExpirationDateKey)
        await userDefaults.removeObject(forKey: service.accessTokenKey)
    }
}
