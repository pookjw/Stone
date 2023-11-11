import Foundation

extension HearthstoneAPIService {
    @objc(HSGameModeResponse)
    @objcMembers
    public actor GameModeResponse: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let name: String
    }
}
