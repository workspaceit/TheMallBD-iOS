import ObjectMapper

class OrdersResponse: Mappable {
    
    var responseStat:ResponseStat!
    var responseData:[Order]!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
