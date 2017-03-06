import ObjectMapper

class UserDetails: Mappable {
    
    var id:Int = 1
    var address:Address!
    var shippingAddress:Address!
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        address         <- map["address"]
        shippingAddress <- map["shippingAddress"]
        createdOn       <- map["createdOn"]
        
    }

}
