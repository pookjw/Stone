import Foundation

extension HearthstoneAPIService {
    @objc(HSCardBackCategoryResponse)
    @objcMembers
    public actor CardBackCategoryResponse: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let name: String
    }
}
