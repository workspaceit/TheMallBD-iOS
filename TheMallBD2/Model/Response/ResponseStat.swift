import ObjectMapper


class ResponseStat: Mappable {
    
    var isLogin:Bool!
    var status:Bool!
    var msg:String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        isLogin    <- map["isLogin"]
        status     <- map["status"]
        msg        <- map["msg"]
       
    }

}
