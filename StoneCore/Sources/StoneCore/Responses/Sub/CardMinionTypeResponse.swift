import Foundation

extension HearthstoneAPIService {
    @objc(HSCardMinionTypeResponse)
    @objcMembers
    public actor CardMinionTypeResponse: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let name: String
        public nonisolated let gameModes: [Int]? // halforc = nil
    }
}
