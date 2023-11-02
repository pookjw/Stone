import Foundation

@objc(HSMetadataResponse)
@objcMembers
public actor HSMetadataResponse: NSObject, Decodable {
    public nonisolated let sets: [HSSetResponse]
    public nonisolated let setGroups: [HSSetGroupResponse]
    public nonisolated let gameModes: [HSGameModeResponse]
    public nonisolated let arenaIds: [Int]
    public nonisolated let types: [HSCardTypeResponse]
    public nonisolated let rarities: [HSCardRarityResponse]
    public nonisolated let classes: [HSClassResponse]
    public nonisolated let minionTypes: [HSCardMinionTypeResponse]
    public nonisolated let spellSchools: [HSCardSpellSchoolResponse]
    public nonisolated let mercenaryRoles: [HSMercenaryRoleResponse]
    public nonisolated let mercenaryFactions: [HSMercenaryFaction]
    public nonisolated let keywords: [HSKeywordResponse]
    public nonisolated let filterableFields: [String]
    public nonisolated let numericFields: [String]
    public nonisolated let cardBackCategories: [HSCardBackCategoryResponse]
}
