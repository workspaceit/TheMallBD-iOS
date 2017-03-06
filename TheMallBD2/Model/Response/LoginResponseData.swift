import ObjectMapper

class LoginResponseData: Mappable {
    
    var accesstoken: String = ""
    var email: String = ""
    var id: Int? = nil
    var user: User? = nil
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        accesstoken     <- map["accesstoken"]
        email           <- map["email"]
        id              <- map["id"]
        user            <- map["user"]
    }
    
}
