import Foundation

extension HearthstoneAPIService {
    @objc(HSCardBackCategoryResponse)
    @objcMembers
    public actor CardBackCategoryResponse: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let name: String
        
        public override nonisolated func isEqual(_ object: Any?) -> Bool {
            guard let other: CardBackCategoryResponse = object as? CardBackCategoryResponse else {
                return super.isEqual(object)
            }
            
            return slug == other.slug
        }
    }
}
