import Foundation

extension HearthstoneAPIService {
    @objc(HSSetResponse)
    @objcMembers
    public actor HSSetResponse: NSObject, Decodable {
        @objc(identifier)
        public nonisolated let id: Int
        public nonisolated let name: String
        public nonisolated let slug: String
        public nonisolated let hyped: Bool
        public nonisolated let type: String // "expansion", "adventure", "base" (Demon Hunter Initiate), "" (Classic Cards)
        public nonisolated let collectibleCount: Int
        public nonisolated let collectibleRevealedCount: Int
        public nonisolated let nonCollectibleCount: Int
        public nonisolated let nonCollectibleRevealedCount: Int
    }
}
