@preconcurrency import Foundation

@objc
public actor HearthstoneAPIService: NSObject {
    private let blizzardAPIService: BlizzardAPIService = .init()
    
    public override init() {
        super.init()
    }
    
    public func metadata(locale: Locale = .current) async throws -> HSMetadataResponse {
        try await request(locale: locale, pathComponents: ["hearthstone", "metadata"], queryItems: [])
    }
    
    private func request<T: Decodable>(locale: Locale, pathComponents: [String], queryItems: [URLQueryItem], type: T.Type = T.self) async throws -> T {
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
