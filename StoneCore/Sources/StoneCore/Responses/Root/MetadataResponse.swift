import Foundation

extension HearthstoneAPIService {
    @objc(HSMetadataResponse)
    @objcMembers
    public actor MetadataResponse: NSObject, Decodable {
        public nonisolated let sets: [HSSetResponse]
        public nonisolated let setGroups: [SetGroupResponse]
        public nonisolated let gameModes: [GameModeResponse]
        public nonisolated let arenaIds: [Int]
        public nonisolated let types: [CardTypeResponse]
        public nonisolated let rarities: [CardRarityResponse]
        public nonisolated let classes: [ClassResponse]
        public nonisolated let minionTypes: [CardMinionTypeResponse]
        public nonisolated let spellSchools: [CardSpellSchoolResponse]
        public nonisolated let mercenaryRoles: [MercenaryRoleResponse]
        public nonisolated let mercenaryFactions: [MercenaryFaction]
        public nonisolated let keywords: [KeywordResponse]
        public nonisolated let filterableFields: [String]
        public nonisolated let numericFields: [String]
        public nonisolated let cardBackCategories: [CardBackCategoryResponse]
    }
}
