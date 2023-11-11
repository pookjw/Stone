import Foundation

extension HearthstoneAPIService {
    @objc(HSCardRarityResponse)
    @objcMembers
    public actor CardRarityResponse: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let craftingRegularCost: Int?
        public nonisolated let craftingGoldCost: Int?
        
        public nonisolated let regularDustCost: Int?
        public nonisolated let goldDustCost: Int?
        
        private enum CodingKeys: CodingKey {
            case slug
            case id
            case craftingCost
            case dustValue
        }
        
        public init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            
            slug = try container.decode(String.self, forKey: .slug)
            id = try container.decode(Int.self, forKey: .id)
            
            let craftingCost: [Int?] = try container.decode([Int?].self, forKey: .craftingCost)
            craftingRegularCost = craftingCost.first ?? nil
            craftingGoldCost = craftingCost.last ?? nil
            
            let dustValue: [Int?] = try container.decode([Int?].self, forKey: .dustValue)
            regularDustCost = dustValue.first ?? nil
            goldDustCost = dustValue.last ?? nil
        }
    }
}
