@preconcurrency import Foundation

@objc
public actor HearthstoneAPIService: NSObject {
    // TODO: etag?
    private let blizzardAPIService: BlizzardAPIService = .init()
    
    public override init() {
        super.init()
    }
    
    public func fetchHSCards() async throws -> FetchHSCardsResponse {
        await print(blizzardAPIService.apiBaseURLSubject.value)
        fatalError()
    }
    
//    @objc
//    public func fetchHSCards(completion: /* */) -> some Cancellable
}

extension HearthstoneAPIService {
    @objc(HearthstoneAPIService_FetchHSCardsResponse)
    public actor FetchHSCardsResponse: NSObject, Decodable {
        public let cards: [HSCardResponse]
        public let cardCount: Int
        public let pageCount: Int
        public let page: Int
    }
}

extension HearthstoneAPIService {
    @objc(HearthstoneAPIService_HSCardResponse)
    public actor HSCardResponse: NSObject, Decodable {
        public let id: Int
        public let collectible: Bool
    }
}
