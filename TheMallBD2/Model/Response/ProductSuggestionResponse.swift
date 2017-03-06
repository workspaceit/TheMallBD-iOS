import ObjectMapper

class ProductSuggestionResponse: Mappable {
    
    var responseStat:ResponseStat!
    var responseData:[ProductSuggestion]!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
