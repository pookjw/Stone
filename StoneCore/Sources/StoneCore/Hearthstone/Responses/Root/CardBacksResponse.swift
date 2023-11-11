import Foundation

extension HearthstoneAPIService {
    @objc(HSCardBacksResponse)
    @objcMembers
    public actor CardBacksResponse: NSObject, Decodable {
        public nonisolated let cardBacks: [CardBackResponse]
        public nonisolated let cardCount: Int
        public nonisolated let pageCount: Int
        public nonisolated let page: Int
    }
}
