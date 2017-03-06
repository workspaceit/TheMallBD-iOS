import ObjectMapper

class ManufacturerResponse: Mappable {
    
    var responseStat: ResponseStat!
    var responseData: [Manufacturer]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
}
