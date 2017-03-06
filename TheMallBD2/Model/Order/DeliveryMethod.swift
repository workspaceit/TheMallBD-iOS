import ObjectMapper

class DeliveryMethod: Mappable {
    
    var id: Int?
    var createdOn = 1
    var deliveryPrice: Double = 0.0
    var delivery_price_limit: Double = 0.0
    var icon: String = ""
    var title: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                      <- map["id"]
        createdOn               <- map["createdOn"]
        deliveryPrice           <- map["deliveryPrice"]
        delivery_price_limit    <- map["delivery_price_limit"]
        icon                    <- map["icon"]
        title                   <- map["title"]
    }
}
