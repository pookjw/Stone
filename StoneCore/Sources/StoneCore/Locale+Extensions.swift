import Foundation

// https://develop.battle.net/documentation/guides/regionality-and-apis

extension Locale.Region {
    static let northAmerica: Locale.Region = .init("021")
    static let europe: Locale.Region = .init("154")
    
    var oAuthBaseURL: URL! {
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
    
    var apiBaseURL: URL! {
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = "https"
        
        switch regionForAPI {
        case .northAmerica:
            urlComponents.host = "us.api.blizzard.com"
        case .europe:
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
    
    var regionForAPI: Locale.Region {
        switch self {
        case .northAmerica, .europe, .southKorea, .taiwan, .chinaMainland:
            return self
        default:
            guard let containingRegion: Locale.Region else {
                return .northAmerica
            }
            
            switch containingRegion {
            case .northAmerica, .europe:
                return containingRegion
            default:
                return .northAmerica
            }
        }
    }
}

extension Locale {
    var localeForAPI: Locale {
        guard
            let languageCode: Locale.LanguageCode = language.languageCode,
            let region: Locale.Region
        else{
            return .init(languageCode: .english, languageRegion: .unitedStates)
        }
        
        switch (languageCode, region) {
        case (.english, .unitedKingdom):
            return .init(languageCode: .english, languageRegion: .unitedKingdom)
        case (.english, _):
            return .init(languageCode: .english, languageRegion: .unitedStates)
        case (.spanish, .mexico):
            return .init(languageCode: .spanish, languageRegion: .mexico)
        case (.spanish, _):
            return .init(languageCode: .spanish, languageRegion: .spain)
        case (.portuguese, .brazil):
            return .init(languageCode: .portuguese, languageRegion: .brazil)
        case (.portuguese, _):
            return .init(languageCode: .portuguese, languageRegion: .portugal)
        case (.french, _):
            return .init(languageCode: .french, languageRegion: .france)
        case (.russian, _):
            return .init(languageCode: .russian, languageRegion: .russia)
        case (.german, _):
            return .init(languageCode: .german, languageRegion: .germany)
        case (.italian, _):
            return .init(languageCode: .italian, languageRegion: .italy)
        case (.korean, _):
            return .init(languageCode: .korean, languageRegion: .southKorea)
        case (.chinese, .taiwan):
            return .init(languageCode: .chinese, languageRegion: .taiwan)
        case (.chinese, _):
            return .init(languageCode: .chinese, languageRegion: .chinaMainland)
        default:
            return .init(languageCode: .english, languageRegion: .unitedStates)
        }
    }
}
