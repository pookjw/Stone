import Foundation

extension HearthstoneAPIService {
    @objc(HSCardSpellSchoolResponse)
    @objcMembers
    public actor CardSpellSchoolResponse: NSObject, Decodable {
        public nonisolated let slug: String
        
        @objc(identifier)
        public nonisolated let id: Int
        
        public nonisolated let name: String
    }
}
