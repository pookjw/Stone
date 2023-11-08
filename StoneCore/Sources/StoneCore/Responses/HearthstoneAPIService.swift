@preconcurrency import Foundation
import HandyMacros

@objc(HearthstoneAPIService)
public actor HearthstoneAPIService: NSObject {
    private let blizzardAPIService: BlizzardAPIService = .init()
    
    public override init() {
        super.init()
    }
    
    @AddObjCCompletionHandler
    public nonisolated func cardBacks(
        locale: Locale = .current,
        cardBackCategory: String? = nil,
        textFilter: String? = nil,
        sort: CardBacksSortRequest = .none,
        page: Int? = nil,
        pageSize: Int? = nil
    ) async throws -> CardBacksResponse {
        try await request(
            locale: locale,
            pathComponents: ["hearthstone", "cardBacks"],
            queryItems: [
                .init(name: "cardBackCategory", value: cardBackCategory),
                .init(name: "textFilter", value: textFilter),
                .init(name: "sort", value: sort.name),
                .init(name: "page", value: page?.description),
                .init(name: "pageSize", value: pageSize?.description)
            ]
        )
    }
    
    @AddObjCCompletionHandler
    public nonisolated func metadata(locale: Locale = .current) async throws -> MetadataResponse {
        try await request(locale: locale, pathComponents: ["hearthstone", "metadata"], queryItems: [])
    }
    
    // TODO
    public nonisolated func metadata(locale: Locale = .current, metadataType: MetadataTypeRequest) async throws -> MetadataResponse {
        try await request(locale: locale, pathComponents: ["hearthstone", "metadata", metadataType.name], queryItems: [])
    }
    
    private nonisolated func request<T: Decodable>(locale: Locale, pathComponents: [String], queryItems: [URLQueryItem], type: T.Type = T.self) async throws -> T {
        var url: URL = await blizzardAPIService.apiBaseURLSubject.value
        
        pathComponents.forEach { pathComponent in
            url.append(components: pathComponent)
        }
        
        var components: URLComponents! = .init(url: url, resolvingAgainstBaseURL: false)
        let accessToken = try await blizzardAPIService.accessToken
        components.queryItems = queryItems + [.init(name: "locale", value: locale.identifier), .init(name: "access_token", value: accessToken)]
        
        var request: URLRequest = .init(url: components.url!, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = "GET"
        
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = .shared
        
        let session: URLSession = .init(configuration: configuration)
        let (data, response): (Data, URLResponse) = try await session.data(for: request)
        
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        let decoder: JSONDecoder = .init()
        let result: T = try decoder.decode(T.self, from: data)
        
        return result
    }
}
