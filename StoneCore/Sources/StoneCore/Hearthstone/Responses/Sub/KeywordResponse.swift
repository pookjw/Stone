import Foundation

extension HearthstoneAPIService {
    @objc(HSKeywordResponse)
    @objcMembers
    public actor KeywordResponse: NSObject, Decodable {
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let slug: String
        public nonisolated let name: String
        public nonisolated let refText: String
        public nonisolated let text: String
        public nonisolated let gameModes: [Int]
    }
}
