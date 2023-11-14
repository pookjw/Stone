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
        
        let expectedRegion: Locale.Region = .northAmerica
        
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
    
    @Test(.tags(["test_localeForAPI"])) func test_localeForAPI() async {
        await #expect(service.localeForAPI == nil)
        
        let expectedLocale: Locale = .init(languageCode: .korean, languageRegion: .southKorea)
        
        let stream: AsyncStream<Locale?> = await service.localeAPIDidChangeStream
        let streamTask: Task<Void, Never> = .init {
            for await newValue in stream {
                if expectedLocale == newValue {
                    return
                }
            }
        }
        
        let notifications: NotificationCenter.Notifications = NotificationCenter.default.notifications(named: .SettingsServiceLocaleForAPIForAPIDidChangeNotification, object: service)
        let notificationTask: Task<Void, Never> = .init {
            for await notification in notifications {
                guard let newValue: Locale = notification.userInfo?[SettingsService.changedObjectKey] as? Locale else {
                    continue
                }
                
                if expectedLocale == newValue {
                    return
                }
            }
        }
        
        await Task.yield()
        await service.set(localeForAPI: expectedLocale)
        await streamTask.value
        await notificationTask.value
        
        let newLocale: Locale? = await service.localeForAPI
        #expect(expectedLocale == newLocale)
    }
}
