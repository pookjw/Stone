import Foundation

extension HearthstoneAPIService {
    @objc(HSCardBackResponse)
    @objcMembers
    public actor CardBackResponse: NSObject, Decodable {
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let sortCategory: Int
        public nonisolated let text: String
        public nonisolated let name: String
        public nonisolated let imageURL: URL
        public nonisolated let slug: String
        
        private enum CodingKeys: CodingKey {
            case id
            case sortCategory
            case text
            case name
            case image
            case slug
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try container.decode(Int.self, forKey: .id)
            self.sortCategory = try container.decode(Int.self, forKey: .sortCategory)
            self.text = try container.decode(String.self, forKey: .text)
            self.name = try container.decode(String.self, forKey: .name)
            self.imageURL = try container.decode(URL.self, forKey: .image)
            self.slug = try container.decode(String.self, forKey: .slug)
        }
    }
}
