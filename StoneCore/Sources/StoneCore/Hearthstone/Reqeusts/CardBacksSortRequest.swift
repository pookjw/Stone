extension HearthstoneAPIService {
    @objc(HSCardBacksSortRequest)
    public enum CardBacksSortRequest: Int, CaseIterable, Hashable, Sendable {
        case none
        case ascendingName
        case descendingName
        case ascendingDateAdded
        case descendingDateAdded
        
        var name: String? {
            switch self {
            case .none:
                nil
            case .ascendingName:
                "name:asc"
            case .descendingName:
                "name:desc"
            case .ascendingDateAdded:
                "dateAdded:asc"
            case .descendingDateAdded:
                "dateAdded:desc"
            }
        }
    }
}


@_cdecl("allHSCardBacksSortRequests")
public func allHSCardBacksSortRequests() -> [Int] {
    HearthstoneAPIService.CardBacksSortRequest
        .allCases
        .map { $0.rawValue }
}

@_cdecl("NSStringFromHSCardBacksSortRequest")
public func NSStringFromHSCardBacksSortRequest(_ value: HearthstoneAPIService.CardBacksSortRequest) -> String? {
    value.name
}
