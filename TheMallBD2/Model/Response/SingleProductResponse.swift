import ObjectMapper

class SingleProductResponse: Mappable {
    
    var responseStat:ResponseStat!
    var responseData:Product!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
