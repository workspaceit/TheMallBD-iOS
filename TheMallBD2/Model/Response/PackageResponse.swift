import ObjectMapper

class PackageResponse: Mappable {
    
    var responseStat:ResponseStat!
    var responseData: [Package]!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
        
    }

}
