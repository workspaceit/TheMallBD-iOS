import ObjectMapper

class PaymentResponse: Mappable {
    
    var responseStat: ResponseStat!
    var responseData: Payment!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
