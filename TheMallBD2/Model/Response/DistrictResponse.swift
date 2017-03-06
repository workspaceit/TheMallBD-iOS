import ObjectMapper

class DistrictResponse: Mappable {
    
    var responseStat: ResponseStat!
    var responseData: [District]!
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        responseStat   <- map["responseStat"]
        responseData   <- map["responseData"]
    }
    
}
