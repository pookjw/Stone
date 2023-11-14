import Foundation

extension Notification.Name {
    fileprivate static let SettingsServiceRegionIdentifierForAPIDidChangeNotification: Notification.Name = .init("SettingsServiceRegionIdentifierForAPIDidChangeNotification")
    fileprivate static let SettingsServiceLocaleForAPIForAPIDidChangeNotification: Notification.Name = .init("SettingsServiceLocaleForAPIForAPIDidChangeNotification")
}

@objc(SettingsService)
@globalActor
public actor SettingsService: NSObject {
    @objc(sharedInstance) public static let shared: SettingsService = .init()
    @objc public static let regionIdentifierForAPIDidChangeNotification: Notification.Name = .SettingsServiceRegionIdentifierForAPIDidChangeNotification
    @objc public static let localeForAPIForAPIDidChangeNotification: Notification.Name = .SettingsServiceLocaleForAPIForAPIDidChangeNotification
    @objc public static let changedObjectKey: String = "changedObjectKey"
    
    private let userDefaults: UserDefaults = .standard
    private var regionIdentifierDidChangeObservation: NSKeyValueObservation!
    private var localeIdentifierForAPIDidChangeObservation: NSKeyValueObservation!
    
    private override init() {
        super.init()
        
        regionIdentifierDidChangeObservation = userDefaults.observe(\.regionIdentifierForAPI, options: .new) { [weak self] _, changes in
            NotificationCenter
                .default
                .post(
                    name: .SettingsServiceRegionIdentifierForAPIDidChangeNotification,
                    object: self,
                    userInfo: [SettingsService.changedObjectKey: (changes.newValue as Any? ?? NSNull())]
                )
        }
        
        localeIdentifierForAPIDidChangeObservation = userDefaults.observe(\.localeIdentifierForAPI, options: .new) { [weak self] _, changes in
            let newValue: Locale?
            if let rawValue: String = changes.newValue ?? nil {
                newValue = .init(identifier: rawValue)
            } else {
                newValue = nil
            }
            
            NotificationCenter
                .default
                .post(
                    name: .SettingsServiceLocaleForAPIForAPIDidChangeNotification,
                    object: self,
                    userInfo: [SettingsService.changedObjectKey: (newValue as Any? ?? NSNull())]
                )
        }
    }
    
    deinit {
        regionIdentifierDidChangeObservation.invalidate()
        localeIdentifierForAPIDidChangeObservation.invalidate()
    }
    
    //
    
    // https://develop.battle.net/documentation/guides/regionality-and-apis
    public nonisolated var availableRegionsForAPI: Set<Locale.Region> {
        [
            .northAmerica, // North America
            .europe, // Europe
            .southKorea,
            .taiwan,
            .chinaMainland
        ]
    }
    
    @objc nonisolated var availableRegionIdentifiersForAPI: Set<String> {
        .init(availableRegionsForAPI.map { $0.identifier })
    }
    
    @objc public nonisolated var availableLocalesForAPI: Set<Locale> {
        .init(
            [
                .init(languageCode: .english, languageRegion: .unitedStates),
                .init(languageCode: .spanish, languageRegion: .mexico),
                .init(languageCode: .portuguese, languageRegion: .brazil),
                .init(languageCode: .english, languageRegion: .unitedStates),
                .init(languageCode: .spanish, languageRegion: .spain),
                .init(languageCode: .french, languageRegion: .france),
                .init(languageCode: .russian, languageRegion: .russia),
                .init(languageCode: .german, languageRegion: .germany),
                .init(languageCode: .portuguese, languageRegion: .portugal),
                .init(languageCode: .italian, languageRegion: .italy),
                .init(languageCode: .korean, languageRegion: .southKorea),
                .init(languageCode: .chinese, languageRegion: .taiwan),
                .init(languageCode: .chinese, languageRegion: .chinaMainland)
            ]
        )
    }
    
    // MARK: - regionForAPI
    
    public var regionForAPIDidChangeStream: AsyncStream<Locale.Region?> {
        .init { continuation in
            let observation: NSKeyValueObservation = userDefaults.observe(\.regionIdentifierForAPI, options: .new) { _, changes in
                if let newValue: String = changes.newValue ?? nil {
                    continuation.yield(with: .success(.init(newValue)))
                } else {
                    continuation.yield(with: .success(nil))
                }
            }
            
            continuation.onTermination = { _ in
                observation.invalidate()
            }
        }
    }
    
    public var regionForAPI: Locale.Region? {
        guard let regionCode: String = userDefaults.string(forKey: #keyPath(UserDefaults.regionIdentifierForAPI)) else {
            return nil
        }
        
        return .init(regionCode)
    }
    
    public func set(regionForAPI: Locale.Region?) {
        if let regionForAPI: Locale.Region {
            assert(availableRegionsForAPI.contains(regionForAPI))
        }
        
        userDefaults.set(regionForAPI?.identifier, forKey: #keyPath(UserDefaults.regionIdentifierForAPI))
    }
    
    @objc public func regionIdentifierForAPI() async -> String? {
        regionForAPI?.identifier
    }
    
    @objc public func set(regionIdentifierForAPI: String?) async {
        userDefaults.set(regionIdentifierForAPI, forKey: #keyPath(UserDefaults.regionIdentifierForAPI))
    }
    
    // MARK: - localeForAPI
    
    public var localeAPIDidChangeStream: AsyncStream<Locale?> {
        .init { continuation in
            let observation: NSKeyValueObservation = userDefaults.observe(\.localeIdentifierForAPI, options: .new) { _, changes in
                if let newValue: String = changes.newValue ?? nil {
                    continuation.yield(with: .success(.init(identifier: newValue)))
                } else {
                    continuation.yield(with: .success(nil))
                }
            }
            
            continuation.onTermination = { _ in
                observation.invalidate()
            }
        }
    }
    
    public var localeForAPI: Locale? {
        guard let localeIdentifierForAPI: String = userDefaults.string(forKey: #keyPath(UserDefaults.localeIdentifierForAPI)) else {
            return nil
        }
        
        return .init(identifier: localeIdentifierForAPI)
    }
    
    public func set(localeForAPI: Locale?) {
        if let localeForAPI: Locale {
            assert(availableLocalesForAPI.contains(localeForAPI))
        }
        
        userDefaults.set(localeForAPI?.identifier, forKey: #keyPath(UserDefaults.localeIdentifierForAPI))
    }
    
    @objc public func localeForAPI() async -> Locale? {
        localeForAPI
    }
    
    @objc public func objc_set(localeForAPI: Locale?) async {
        userDefaults.set(localeForAPI?.identifier, forKey: #keyPath(UserDefaults.localeIdentifierForAPI))
    }
    
    //
    
    private func destory() {
        userDefaults.removeObject(forKey: #keyPath(UserDefaults.regionIdentifierForAPI))
        userDefaults.removeObject(forKey: #keyPath(UserDefaults.localeIdentifierForAPI))
    }
}

extension UserDefaults {
    @objc fileprivate dynamic var regionIdentifierForAPI: String? {
        string(forKey: #keyPath(regionIdentifierForAPI))
    }
    
    @objc fileprivate dynamic var localeIdentifierForAPI: String? {
        string(forKey: #keyPath(localeIdentifierForAPI))
    }
}
