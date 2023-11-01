@preconcurrency import Foundation

actor BlizzardAPIService {
    var accessToken: String {
        get async throws {
            if
                let accessToken: String = userDefaults.string(forKey: accessTokenKey),
                let accessTokenExpirationDate: Date = userDefaults.object(forKey: accessTokenExpirationDateKey) as? Date,
                accessTokenExpirationDate > .now
            {
                return accessToken
            } else {
                let (accessToken, expirationDate): (String, Date) = try await requestAccessToken()
                userDefaults.set(accessToken, forKey: accessTokenKey)
                userDefaults.set(expirationDate, forKey: accessTokenExpirationDateKey)
                
                return accessToken
            }
        }
    }
    
    private(set) var apiBaseURLSubject: CurrentValueAsyncSubject<URL>
    private var oAuthBaseURL: CurrentValueAsyncSubject<URL>
    
    private let userDefaults: UserDefaults = .standard
    
    private let currentLocaleDidChangeTask: Task<Void, Never>
    
    private let accessTokenExpirationDateKey: String = "accessTokenExpirationDate"
    private let accessTokenKey: String = "accessToken"
    
    init() {
        let region: Locale.Region = Locale.current.region ?? .unitedStates
        apiBaseURLSubject = .init(value: region.apiBaseURL)
        oAuthBaseURL = .init(value: region.oAuthBaseURL)
        
        currentLocaleDidChangeTask = .init { [apiBaseURLSubject, oAuthBaseURL] in
            for await notification in NotificationCenter.default.notifications(named: NSLocale.currentLocaleDidChangeNotification) {
                let region: Locale.Region = Locale.current.region ?? .unitedStates
                await apiBaseURLSubject.yield(region.apiBaseURL)
                await oAuthBaseURL.yield(region.oAuthBaseURL)
            }
        }
    }
    
    deinit {
        currentLocaleDidChangeTask.cancel()
    }
    
    private func requestAccessToken() async throws -> (accessToken: String, expirationDate: Date) {
        let oAuthBaseURL: URL = await oAuthBaseURL.value
        var urlComponents: URLComponents = .init(url: oAuthBaseURL as Foundation.URL, resolvingAgainstBaseURL: false)!
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            .init(name: "grant_type", value: "client_credentials")
        ]
        
        let url: URL = urlComponents.url!
        var request: URLRequest = .init(url: url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Authorization": "Basic OTQ4N2Q4ODdkOGM1NDE5MDljYzE3OTc0MWFlYTYwMjU6ZzZGVzNHVVV4dzhoNzZha1lPZ0RSNHd6eHhsTUYyN2U="]
        
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.waitsForConnectivity = true
        let session: URLSession = .init(configuration: configuration)
        
        let (data, response): (Data, URLResponse) = try await session.data(for: request)
//        print(String(data: data, encoding: .utf8)!)
        
        let decoder: JSONDecoder = .init()
        let tokenResponse: BlizzardAPITokenResponse = try decoder.decode(BlizzardAPITokenResponse.self, from: data)
        
        let accessToken: String = tokenResponse.accessToken
        
        let expirationDate: Date
        if let timestampString: String = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Date") as? String {
            let dateFormatter: DateFormatter = .init()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
            dateFormatter.locale = .init(identifier: "en_US_POSIX")
            let timestamp = dateFormatter.date(from: timestampString) ?? .now
            expirationDate = timestamp.addingTimeInterval(.init(tokenResponse.expiresIn))
        } else {
            expirationDate = .now
        }
        
        return (accessToken, expirationDate)
    }
}

fileprivate struct BlizzardAPITokenResponse: Hashable, Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int64
    let sub: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case sub = "sub"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: BlizzardAPITokenResponse.CodingKeys.accessToken)
        tokenType = try container.decode(String.self, forKey: BlizzardAPITokenResponse.CodingKeys.tokenType)
        expiresIn = try container.decode(Int64.self, forKey: BlizzardAPITokenResponse.CodingKeys.expiresIn)
        sub = try container.decode(String.self, forKey: BlizzardAPITokenResponse.CodingKeys.sub)
    }
}

extension Locale.Region {
    /// https://develop.battle.net/documentation/guides/regionality-and-apis
    fileprivate var apiBaseURL: URL! {
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = "https"
        
        switch self {
        case .unitedStates, .mexico, .brazil:
            urlComponents.host = "us.api.blizzard.com"
        case .unitedKingdom, .spain, .france, .russia, .denmark, .portugal, .italy:
            urlComponents.host = "eu.api.blizzard.com"
        case .southKorea:
            urlComponents.host = "kr.api.blizzard.com"
        case .taiwan:
            urlComponents.host = "tw.api.blizzard.com"
        case .chinaMainland:
            urlComponents.host = "gateway.battlenet.com.cn"
        default:
            urlComponents.host = "us.api.blizzard.com"
        }
        
        return urlComponents.url
    }
    
    /// https://develop.battle.net/documentation/guides/using-oauth
    fileprivate var oAuthBaseURL: URL! {
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = "https"
        
        switch self {
        case .chinaMainland:
            urlComponents.host = "oauth.battlenet.com.cn"
        default:
            urlComponents.host = "oauth.battle.net"
        }
        
        return urlComponents.url
    }
}
