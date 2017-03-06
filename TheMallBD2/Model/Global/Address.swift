import ObjectMapper

class Address: Mappable {
    
    var country:String = ""
    var city:String = ""
    var zipcode:String = ""
    var address:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        country    <- map["country"]
        city         <- map["city"]
        zipcode      <- map["zipCode"]
        address      <- map["address"]
        
    }

}
