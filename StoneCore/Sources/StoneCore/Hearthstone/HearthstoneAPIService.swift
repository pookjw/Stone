@preconcurrency import Foundation
import HandyMacros

@objc(HearthstoneAPIService)
public actor HearthstoneAPIService: NSObject {
    private let accessTokenService: BlizzardAPIAccessTokenService = .shared
    private let settingsService: SettingsService = .shared
    
    public override init() {
        super.init()
    }
    
    @AddObjCCompletionHandler
    public nonisolated func cardBacks(
        cardBackCategory: String? = nil,
        textFilter: String? = nil,
        sort: CardBacksSortRequest = .none,
        page: Int? = nil,
        pageSize: Int? = nil
    ) async throws -> CardBacksResponse {
        try await request(
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
    public nonisolated func metadata() async throws -> MetadataResponse {
        try await request(pathComponents: ["hearthstone", "metadata"], queryItems: [])
    }
    
    // TODO
    public nonisolated func metadata(metadataType: MetadataTypeRequest) async throws -> MetadataResponse {
        try await request(pathComponents: ["hearthstone", "metadata", metadataType.name], queryItems: [])
    }
    
    private nonisolated func request<T: Decodable>(pathComponents: [String], queryItems: [URLQueryItem], type: T.Type = T.self) async throws -> T {
        let region: Locale.Region = await settingsService.regionForAPI ?? Locale.current.region?.regionForAPI ?? .northAmerica
        var url: URL = region.apiBaseURL
        
        pathComponents.forEach { pathComponent in
            url.append(components: pathComponent)
        }
        
        var components: URLComponents! = .init(url: url, resolvingAgainstBaseURL: false)
        let accessToken = try await accessTokenService.accessToken(region: region)
        let locale: Locale = await settingsService.localeForAPI ?? Locale.current.localeForAPI
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
