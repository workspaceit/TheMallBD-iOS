import ObjectMapper

class Wishlist: Mappable {
    
    var product:Product!
    var createdOn:String=""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        product        <- map["product"]
        createdOn      <- map["createdOn"]
        
    }


}
