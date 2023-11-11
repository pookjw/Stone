import Foundation

extension HearthstoneAPIService {
    @objc(HSClassResponse)
    @objcMembers
    public actor ClassResponse: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let name: String
        public nonisolated let cardId: Int? // Default Hero Skin. nil when neutral
        
        public nonisolated let heroPowerCardId: Int? // nil when neutral
        public nonisolated let alternateHeroCardIds: [Int]? // Hero Skins. nil when neutral
    }
}
