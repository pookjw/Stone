extension HearthstoneAPIService {
    @objc(HSMetadataTypeRequest)
    @available(*, deprecated, message: "Unused")
    public enum MetadataTypeRequest: Int, CaseIterable, Hashable, Sendable {
        case sets
        case setGroups
        case gameModes
        case arenaIds
        case types
        case rarities
        case classes
        case minionTypes
        case spellSchools
        case mercenaryRoles
        case mercenaryFactions
        case keywords
        case filterableFields
        case numericFields
        case cardBackCategories
        
        var name: String {
            switch self {
            case .sets:
                "sets"
            case .setGroups:
                "setGroups"
            case .gameModes:
                "gameModes"
            case .arenaIds:
                "arenaIds"
            case .types:
                "types"
            case .rarities:
                "rarities"
            case .classes:
                "classes"
            case .minionTypes:
                "minionTypes"
            case .spellSchools:
                "spellSchools"
            case .mercenaryRoles:
                "mercenaryRoles"
            case .mercenaryFactions:
                "mercenaryFactions"
            case .keywords:
                "keywords"
            case .filterableFields:
                "filterableFields"
            case .numericFields:
                "numericFields"
            case .cardBackCategories:
                "cardBackCategories"
            }
        }
    }
}
