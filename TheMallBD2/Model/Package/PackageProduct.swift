import ObjectMapper

class PackageProduct: Mappable {
    
    var id: Int = 0
    var packageId: String = ""
    var product: Product!
    var quantity: String = ""
    var price: String = ""
    var createdOn: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        packageId <- map["packageId"]
        product <- map["product"]
        quantity <- map["quantity"]
        price <- map["price"]
        createdOn <- map["createdOn"]
    }
    
}
