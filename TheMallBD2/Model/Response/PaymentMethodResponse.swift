import ObjectMapper

class PaymentMethodResponse: Mappable {
    
    var responseStat: ResponseStat!
    var responseData: [PaymentMethod]!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
