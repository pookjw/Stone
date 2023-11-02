import Foundation

@objc
@objcMembers
public actor HSCardMinionTypeResponse: NSObject, Decodable {
    public nonisolated let slug: String
    
    @objc(identifier)
    public nonisolated let id: Int
    
    public nonisolated let name: String
    public nonisolated let gameModes: [Int]? // halforc = nil
}
