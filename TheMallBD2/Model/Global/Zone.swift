import ObjectMapper

class Zone: Mappable {
    
    var id:Int = 0
    var code:String = ""
    var city:String = ""
    var area:String = ""
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        code         <- map["code"]
        city      <- map["city"]
        area      <- map["area"]
        createdOn      <- map["createdOn"]
        
    }

}
