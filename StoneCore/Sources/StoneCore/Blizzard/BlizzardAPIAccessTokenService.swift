@preconcurrency import Foundation
@preconcurrency import CoreData

@globalActor
actor BlizzardAPIAccessTokenService {
    static let shared: BlizzardAPIAccessTokenService = .init()
    
    private let coreDataStack: CoreDataStack = {
        let managedObjectModel: NSManagedObjectModel = .init()
        managedObjectModel.entities = [BlizzardAPIAccessToken._entity]
        
        let coreDataStack: CoreDataStack = .init(name: "BlizzardAPITokenService", managedObjectModel: managedObjectModel)
        return coreDataStack
    }()
    
    func accessToken(region: Locale.Region) async throws -> String {
        let (cachedAccessToken, cachedExpirationDate, fetchedObjects): (String?, Date?, [BlizzardAPIAccessToken]) = try await fetchAccessTokenCache(region: region)
        
        if
            let cachedAccessToken: String,
            let cachedExpirationDate: Date,
            cachedExpirationDate > .now
        {
            return cachedAccessToken
        }
        //
        
        let (accessToken, expirationDate): (String, Date) = try await requestAccessToken(region: region)
        let context: NSManagedObjectContext = try await coreDataStack.context
        
        try await context.perform {
            for fetchedObject in fetchedObjects {
                context.delete(fetchedObject)
            }
            
            let accessTokenObject: BlizzardAPIAccessToken = .init(context: context)
            accessTokenObject.regionCode = region.identifier
            accessTokenObject.expirationDate = expirationDate
            accessTokenObject.accessToken = accessToken
            
            try context.save()
        }
        
        return accessToken
    }
    
    private func fetchAccessTokenCache(region: Locale.Region) async throws -> (accessToken: String?, expirationDate: Date?, fetchedObjects: [BlizzardAPIAccessToken]) {
        let regionCode: String = region.identifier
        
        let predicate: Predicate<BlizzardAPIAccessToken> = #Predicate<BlizzardAPIAccessToken> { token in
            token.regionCode == regionCode
        }
        
        let fetchRequest: NSFetchRequest<BlizzardAPIAccessToken> = .init(entityName: "BlizzardAPIAccessToken")
        fetchRequest.predicate = .init(predicate)
        
        let context: NSManagedObjectContext = try await coreDataStack.context
        
        let result: (String?, Date?, [BlizzardAPIAccessToken]) = try await context.perform {
            let objects: [BlizzardAPIAccessToken] = try context.fetch(fetchRequest)
            
            guard let firstObject: BlizzardAPIAccessToken = objects.first else {
                return (nil, nil, objects)
            }
            
            let expirationDate: Date? = firstObject.expirationDate
            let accessToken: String = firstObject.accessToken
            
            return (accessToken, expirationDate, objects)
        }
        
        
        return result
    }
    
    private func requestAccessToken(region: Locale.Region) async throws -> (accessToken: String, expirationDate: Date) {
        let oAuthBaseURL: URL = region
            .oAuthBaseURL
            .appending(path: "oauth")
            .appending(path: "token")
        
        var urlComponents: URLComponents = .init(url: oAuthBaseURL as Foundation.URL, resolvingAgainstBaseURL: false)!
        
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

fileprivate final class BlizzardAPIAccessToken: NSManagedObject, @unchecked Sendable {
    static var _entity: NSEntityDescription {
        let entity: NSEntityDescription = .init()
        entity.name = "BlizzardAPIAccessToken"
        entity.managedObjectClassName = NSStringFromClass(BlizzardAPIAccessToken.self)
        
        //
        
        let regionCodeAttributeDescription: NSAttributeDescription = .init()
        regionCodeAttributeDescription.name = #keyPath(BlizzardAPIAccessToken.regionCode)
        regionCodeAttributeDescription.type = .string
        regionCodeAttributeDescription.isOptional = false
        
        let expirationDateAttributeDescription: NSAttributeDescription = .init()
        expirationDateAttributeDescription.name = #keyPath(BlizzardAPIAccessToken.expirationDate)
        expirationDateAttributeDescription.type = .date
        expirationDateAttributeDescription.isOptional = true
        
        let accessTokenAttributeDescription: NSAttributeDescription = .init()
        accessTokenAttributeDescription.name = #keyPath(BlizzardAPIAccessToken.accessToken)
        accessTokenAttributeDescription.type = .string
        accessTokenAttributeDescription.isOptional = false
        
        //
        
        entity.properties = [
            regionCodeAttributeDescription,
            expirationDateAttributeDescription,
            accessTokenAttributeDescription
        ]
        
        entity.uniquenessConstraints = [[regionCodeAttributeDescription]]
        
        return entity
    }
    
    @NSManaged var regionCode: String
    @NSManaged var expirationDate: Date?
    @NSManaged var accessToken: String
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
