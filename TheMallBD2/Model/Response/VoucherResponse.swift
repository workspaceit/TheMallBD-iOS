import ObjectMapper

class VoucherResponse: Mappable {
    
    var responseStat: ResponseStat!
    var responseData: VoucherDiscount!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
