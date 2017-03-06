import ObjectMapper

class Response1: Mappable {
    
    var responseStat:ResponseStat!
    var responseData:AnyObject!

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
        
    }

}
