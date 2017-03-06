import ObjectMapper

class CustomerDiscountResponse: Mappable {
    
    var responseStat: ResponseStat!
    var responseData: [CustomerPurchaseDiscount] = []
    var discountMessage: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat    <- map["responseStat"]
        responseData    <- map["responseData"]
        discountMessage <- map["discountMessage"]
    }

}
