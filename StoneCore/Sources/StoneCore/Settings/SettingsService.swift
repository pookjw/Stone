import Foundation

extension Notification.Name {
    fileprivate static let SettingsServiceRegionIdentifierForAPIDidChangeNotification: Notification.Name = .init("SettingsServiceRegionIdentifierForAPIDidChangeNotification")
    fileprivate static let SettingsServiceLanguageCodeIdentifierForAPIForAPIDidChangeNotification: Notification.Name = .init("SettingsServiceLanguageCodeIdentifierForAPIForAPIDidChangeNotification")
}

@objc(SettingsService)
@globalActor
public actor SettingsService: NSObject {
    @objc(sharedInstance) public static let shared: SettingsService = .init()
    @objc public static let regionIdentifierForAPIDidChangeNotification: Notification.Name = .SettingsServiceRegionIdentifierForAPIDidChangeNotification
    @objc public static let languageCodeIdentifierForAPIForAPIDidChangeNotification: Notification.Name = .SettingsServiceLanguageCodeIdentifierForAPIForAPIDidChangeNotification
    @objc public static let changedObjectKey: String = "changedObjectKey"
    
    public nonisolated var availableRegionsForAPI: [Locale.Region] {
        fatalError("TODO")
    }
    
    @objc nonisolated var availableRegionIdentifiersForAPI: [String] {
        availableRegionsForAPI
            .map { $0.identifier }
    }
    
    public nonisolated var availableLanguageCodesForAPI: [Locale.LanguageCode] {
        fatalError()
    }
    
    @objc public nonisolated var availableLanguageCodeIdentifiersForAPI: [String] {
        availableLanguageCodesForAPI
            .map { $0.identifier }
    }
    
    private let userDefaults: UserDefaults = .standard
    private var regionIdentifierDidChangeObservation: NSKeyValueObservation!
    private var lauguaceCodeIdentifierForAPIDidChangeObservation: NSKeyValueObservation!
    
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
        
        lauguaceCodeIdentifierForAPIDidChangeObservation = userDefaults.observe(\.lauguaceCodeIdentifierForAPI, options: .new) { [weak self] _, changes in
            NotificationCenter
                .default
                .post(
                    name: .SettingsServiceLanguageCodeIdentifierForAPIForAPIDidChangeNotification,
                    object: self,
                    userInfo: [SettingsService.changedObjectKey: (changes.newValue as Any? ?? NSNull())]
                )
        }
    }
    
    deinit {
        regionIdentifierDidChangeObservation.invalidate()
        lauguaceCodeIdentifierForAPIDidChangeObservation.invalidate()
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
        userDefaults.set(regionForAPI?.identifier, forKey: #keyPath(UserDefaults.regionIdentifierForAPI))
    }
    
    @objc public func regionIdentifierForAPI() async -> String? {
        regionForAPI?.identifier
    }
    
    @objc public func set(regionIdentifierForAPI: String?) async {
        userDefaults.set(regionIdentifierForAPI, forKey: #keyPath(UserDefaults.regionIdentifierForAPI))
    }
    
    // MARK: - lauguaceCodeIdentifierForAPI
    
    public var lauguaceCodeForAPIDidChangeStream: AsyncStream<Locale.LanguageCode?> {
        .init { continuation in
            let observation: NSKeyValueObservation = userDefaults.observe(\.lauguaceCodeIdentifierForAPI, options: .new) { _, changes in
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
    
    public var lauguaceCodeForAPI: Locale.LanguageCode? {
        guard let lauguaceCodeIdentifierForAPI: String = userDefaults.string(forKey: #keyPath(UserDefaults.lauguaceCodeIdentifierForAPI)) else {
            return nil
        }
        
        return .init(lauguaceCodeIdentifierForAPI)
    }
    
    public func set(lauguaceCodeForAPI: Locale.LanguageCode?) {
        userDefaults.set(lauguaceCodeForAPI?.identifier, forKey: #keyPath(UserDefaults.lauguaceCodeIdentifierForAPI))
    }
    
    @objc public func lauguaceCodeIdentifierForAPI() async -> String? {
        lauguaceCodeForAPI?.identifier
    }
    
    @objc public func set(lauguaceCodeIdentifierForAPI: String?) async {
        userDefaults.set(lauguaceCodeIdentifierForAPI, forKey: #keyPath(UserDefaults.lauguaceCodeIdentifierForAPI))
    }
    
    //
    
    private func destory() {
        userDefaults.removeObject(forKey: #keyPath(UserDefaults.regionIdentifierForAPI))
        userDefaults.removeObject(forKey: #keyPath(UserDefaults.lauguaceCodeIdentifierForAPI))
    }
}

extension UserDefaults {
    @objc fileprivate dynamic var regionIdentifierForAPI: String? {
        string(forKey: #keyPath(regionIdentifierForAPI))
    }
    
    @objc fileprivate dynamic var lauguaceCodeIdentifierForAPI: String? {
        string(forKey: #keyPath(lauguaceCodeIdentifierForAPI))
    }
}
