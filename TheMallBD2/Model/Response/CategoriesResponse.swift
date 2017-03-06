import ObjectMapper

class CategoriesResponse: Mappable {
    
    
    var responseStat:ResponseStat!
    var responseData:[Categories]!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
        
    }

}
