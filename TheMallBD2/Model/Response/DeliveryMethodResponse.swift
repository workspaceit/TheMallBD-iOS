import ObjectMapper

class DeliveryMethodResponse: Mappable {
    
    var responseStat: ResponseStat!
    var responseData: [DeliveryMethod]!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
