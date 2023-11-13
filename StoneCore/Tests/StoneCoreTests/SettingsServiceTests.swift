import Foundation
import Testing
@testable @_private(sourceFile: "SettingsService.swift") import StoneCore

actor SettingsServiceTests {
    private let service: SettingsService = .shared
    
    init() async {
        await service.destory()
    }
    
    @Test(.tags(["test_regionForAPI"])) func test_regionForAPI() async {
        await #expect(service.regionForAPI == nil)
        
        let expectedRegion: Locale.Region = .unitedStates
        
        let stream: AsyncStream<Locale.Region?> = await service.regionForAPIDidChangeStream
        let streamTask: Task<Void, Never> = .init {
            for await newValue in stream {
                if expectedRegion == newValue {
                    return
                }
            }
        }
        
        let notifications: NotificationCenter.Notifications = NotificationCenter.default.notifications(named: .SettingsServiceRegionIdentifierForAPIDidChangeNotification, object: service)
        let notificationTask: Task<Void, Never> = .init {
            for await notification in notifications {
                guard let rawValue: String = notification.userInfo?[SettingsService.changedObjectKey] as? String else {
                    continue
                }
                
                let newValue: Locale.Region = .init(rawValue)
                if expectedRegion == newValue {
                    return
                }
            }
        }
        
        await Task.yield()
        
        await service.set(regionForAPI: expectedRegion)
        await streamTask.value
        await notificationTask.value
        
        let newRegion: Locale.Region? = await service.regionForAPI
        #expect(expectedRegion == newRegion)
    }
    
    @Test(.tags(["test_lauguaceCodeForAPI"])) func test_lauguaceCodeForAPI() async {
        await #expect(service.lauguaceCodeForAPI == nil)
        
        let expectedLanguageCode: Locale.LanguageCode = .korean
        
        let stream: AsyncStream<Locale.LanguageCode?> = await service.lauguaceCodeForAPIDidChangeStream
        let streamTask: Task<Void, Never> = .init {
            for await newValue in stream {
                if expectedLanguageCode == newValue {
                    return
                }
            }
        }
        
        let notifications: NotificationCenter.Notifications = NotificationCenter.default.notifications(named: .SettingsServiceLanguageCodeIdentifierForAPIForAPIDidChangeNotification, object: service)
        let notificationTask: Task<Void, Never> = .init {
            for await notification in notifications {
                guard let rawValue: String = notification.userInfo?[SettingsService.changedObjectKey] as? String else {
                    continue
                }
                
                let newValue: Locale.LanguageCode = .init(rawValue)
                if expectedLanguageCode == newValue {
                    return
                }
            }
        }
        
        await Task.yield()
        await service.set(lauguaceCodeForAPI: expectedLanguageCode)
        await streamTask.value
        await notificationTask.value
        
        let newLanguageCode: Locale.LanguageCode? = await service.lauguaceCodeForAPI
        #expect(expectedLanguageCode == newLanguageCode)
    }
}
