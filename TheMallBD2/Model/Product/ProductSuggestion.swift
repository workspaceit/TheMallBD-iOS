import ObjectMapper

class ProductSuggestion: Mappable {
    
    var id: Int = 0
    var product_title: String = ""
    var image_name: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        product_title   <- map["product_title"]
        image_name      <- map["image_name"]
    }
    
}
