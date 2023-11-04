import Foundation

extension HearthstoneAPIService {
    @objc(HSMercenaryFaction)
    @objcMembers
    public actor MercenaryFaction: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let name: String
    }
}
