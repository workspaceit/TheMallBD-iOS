import ObjectMapper

class LoginResponse: Mappable {
    
    var responseStat: ResponseStat!
    var responseData: LoginResponseData!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
