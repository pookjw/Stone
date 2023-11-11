import Foundation

extension HearthstoneAPIService {
    @objc(HSMercenaryRoleResponse)
    @objcMembers
    public actor MercenaryRoleResponse: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let name: String
    }
}
