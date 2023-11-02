import Foundation

@objc
@objcMembers
public actor HSMercenaryRoleResponse: NSObject, Decodable {
    public nonisolated let slug: String
    
    @objc(identifier)
    public nonisolated let id: Int
    
    public nonisolated let name: String
}
