import Foundation

@objc(HSSetGroupResponse)
@objcMembers
public actor HSSetGroupResponse: NSObject, Decodable {
    public nonisolated let slug: String
    public nonisolated let year: Int?
    public nonisolated let svgURL: URL?
    public nonisolated let cardSets: [String]
    public nonisolated let name: String
    public nonisolated let standard: Bool?
    public nonisolated let icon: String?
    
    private enum CodingKeys: CodingKey {
        case slug
        case year
        case svg
        case cardSets
        case name
        case standard
        case icon
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        slug = try container.decode(String.self, forKey: HSSetGroupResponse.CodingKeys.slug)
        year = try container.decodeIfPresent(Int.self, forKey: HSSetGroupResponse.CodingKeys.year)
        
        if let svg: String = try container.decodeIfPresent(String?.self, forKey: .svg) ?? nil {
            svgURL = .init(string: svg)
        } else {
            svgURL = nil
        }
        
        cardSets = try container.decode([String].self, forKey: HSSetGroupResponse.CodingKeys.cardSets)
        name = try container.decode(String.self, forKey: HSSetGroupResponse.CodingKeys.name)
        
        if let standard: Bool = try container.decodeIfPresent(Bool.self, forKey: HSSetGroupResponse.CodingKeys.standard) {
            self.standard = standard
        } else if slug == "standard" {
            self.standard = true
        } else if slug == "wild" {
            self.standard = false
        } else {
            self.standard = nil
        }
        
        icon = try container.decodeIfPresent(String?.self, forKey: HSSetGroupResponse.CodingKeys.icon) ?? nil
    }
}
