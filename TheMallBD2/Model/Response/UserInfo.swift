import ObjectMapper

class UserInfo: Mappable {
    
    var accesstoken: String = ""
    var email: String = ""
    var id: Int!
    var user: User!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        accesstoken     <- map["accesstoken"]
        email           <- map["email"]
        id              <- map["id"]
        user            <- map["user"]
    }
    
}
