//import Foundation
//
//extension Locale.Region {
//    /// https://develop.battle.net/documentation/guides/regionality-and-apis
//    var apiBaseURL: URL! {
//        var urlComponents: URLComponents = .init()
//        urlComponents.scheme = "https"
//        
//        switch self {
//        case .unitedStates, .mexico, .brazil:
//            urlComponents.host = "us.api.blizzard.com"
//        case .unitedKingdom, .spain, .france, .russia, .denmark, .portugal, .italy:
//            urlComponents.host = "eu.api.blizzard.com"
//        case .southKorea:
//            urlComponents.host = "kr.api.blizzard.com"
//        case .taiwan:
//            urlComponents.host = "tw.api.blizzard.com"
//        case .chinaMainland:
//            urlComponents.host = "gateway.battlenet.com.cn"
//        default:
//            urlComponents.host = "us.api.blizzard.com"
//        }
//        
//        return urlComponents.url
//    }
//    
//    /// https://develop.battle.net/documentation/guides/using-oauth
//    var oAuthBaseURL: URL! {
//        var urlComponents: URLComponents = .init()
//        urlComponents.scheme = "https"
//        
//        switch self {
//        case .chinaMainland:
//            urlComponents.host = "oauth.battlenet.com.cn"
//        default:
//            urlComponents.host = "oauth.battle.net"
//        }
//        
//        return urlComponents.url
//    }
//}
