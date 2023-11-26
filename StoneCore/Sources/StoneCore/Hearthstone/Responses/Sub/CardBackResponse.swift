import Foundation

extension HearthstoneAPIService {
    @objc(HSCardBackResponse)
    @objcMembers
    public actor CardBackResponse: NSObject, NSSecureCoding, Decodable {
        public static var supportsSecureCoding: Bool {
            true
        }
        
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
        
        public init?(coder: NSCoder) {
            self.id = coder.decodeInteger(forKey: #keyPath(id))
            self.sortCategory = coder.decodeInteger(forKey: #keyPath(sortCategory))
            self.text = coder.decodeObject(of: NSString.self, forKey: #keyPath(text))! as String
            self.name = coder.decodeObject(of: NSString.self, forKey: #keyPath(name))! as String
            self.imageURL = coder.decodeObject(of: NSURL.self, forKey: #keyPath(imageURL))! as URL
            self.slug = coder.decodeObject(of: NSString.self, forKey: #keyPath(slug))! as String
        }
        
        public nonisolated func encode(with coder: NSCoder) {
            coder.encode(id, forKey: #keyPath(id))
            coder.encode(sortCategory, forKey: #keyPath(sortCategory))
            coder.encode(text, forKey: #keyPath(text))
            coder.encode(name, forKey: #keyPath(name))
            coder.encode(imageURL, forKey: #keyPath(imageURL))
            coder.encode(slug, forKey: #keyPath(slug))
        }
    }
}
