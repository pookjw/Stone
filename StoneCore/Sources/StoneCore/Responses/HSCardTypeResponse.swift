import Foundation

@objc
@objcMembers
public actor HSCardTypeResponse: NSObject, Decodable {
    public nonisolated let slug: String
    
    @objc(identifier)
    public nonisolated let id: Int
    
    public nonisolated let name: String
    public nonisolated let gameModes: [Int]
}
