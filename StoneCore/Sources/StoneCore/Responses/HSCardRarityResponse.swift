import Foundation

@objc
@objcMembers
public actor HSCardRarityResponse: NSObject, Decodable {
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
        
        self.slug = try container.decode(String.self, forKey: HSCardRarityResponse.CodingKeys.slug)
        self.id = try container.decode(Int.self, forKey: HSCardRarityResponse.CodingKeys.id)
        
        let craftingCost: [Int?] = try container.decode([Int?].self, forKey: .craftingCost)
        self.craftingRegularCost = craftingCost.first ?? nil
        self.craftingGoldCost = craftingCost.last ?? nil
        
        let dustValue: [Int?] = try container.decode([Int?].self, forKey: .dustValue)
        self.regularDustCost = dustValue.first ?? nil
        self.goldDustCost = dustValue.last ?? nil
    }
}
