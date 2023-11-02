import Foundation

@objc(HSGameModeResponse)
@objcMembers
public actor HSGameModeResponse: NSObject, Decodable {
    public nonisolated let slug: String
    
    @objc(identifier)
    public nonisolated let id: Int
    
    public nonisolated let name: String
}
