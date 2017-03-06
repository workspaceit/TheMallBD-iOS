import ObjectMapper

class ReviewResponse: Mappable {
    
    var responseStat:ResponseStat!
    var responseData:[Review]!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }

}
