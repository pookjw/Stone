import Foundation

extension HearthstoneAPIService {
    @objc(HSCardResponse)
    @objcMembers
    public actor CardResponse: NSObject, Decodable {
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let collectible: Bool // TODO: It's Int
        public nonisolated let slug: String
        public nonisolated let classId: Int
        public nonisolated let multiClassIds: [Int]
        
    }
}
