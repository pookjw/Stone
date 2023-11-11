import Foundation
import HandyMacros

@objc(SettingsService)
@globalActor
public actor SettingsService: NSObject {
    @objc(sharedInstance) public static let shared: SettingsService = .init()
    
    public nonisolated var availableRegionsForAPI: [Locale.Region] {
        fatalError("TODO")
    }
    
    @objc nonisolated var availableRegionIdentifiersForAPI: [String] {
        availableRegionsForAPI
            .map { $0.identifier }
    }
    
    @objc public nonisolated var availableLocalesForAPI: [Locale] {
        fatalError("TODO")
    }
    
    private let userDefaults: UserDefaults = .standard
    
    private override init() {
        super.init()
    }
    
    // MARK: - regionForAPI
    
    public var regionForAPI: Locale.Region? {
        guard let regionCode: String = userDefaults.string(forKey: "regionIdentifierForAPI") else {
            return nil
        }
        
        return .init(regionCode)
    }
    
    public func set(regionForAPI: Locale.Region?) {
        userDefaults.set(regionForAPI?.identifier, forKey: "regionIdentifierForAPI")
    }
    
    @objc public func regionIdentifierForAPI() async -> String? {
        regionForAPI?.identifier
    }
    
    @objc public func set(regionIdentifierForAPI: String?) async {
        let region: Locale.Region?
        if let regionIdentifierForAPI: String {
            region = .init(regionIdentifierForAPI)
        } else {
            region = nil
        }
        
        set(regionForAPI: region)
    }
    
    // MARK: - localeForAPI
    
    public var localeForAPI: Locale? {
        guard let localeIdentifier: String = userDefaults.string(forKey: "localeIdentifierForAPI") else {
            return nil
        }
        
        return .init(identifier: localeIdentifier)
    }
    
    @objc public func set(localeForAPI: Locale?) async {
        userDefaults.set(localeForAPI?.identifier, forKey: "localeIdentifierForAPI")
    }
    
    @objc public func localeForAPI() async -> Locale? {
        localeForAPI
    }
}
