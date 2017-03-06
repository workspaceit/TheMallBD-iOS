import ObjectMapper

class UserResponse: Mappable {
    var responseStat:ResponseStat!
    var responseData: UserInfo?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        responseStat    <- map["responseStat"]
        responseData    <- map["responseData"]
    }
}
