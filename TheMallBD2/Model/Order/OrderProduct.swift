import ObjectMapper

class OrderProduct: Mappable {
    var id: Int = 0
    var productQuantity: Int = 0
    var packageQuantity: Int = 0
    var price: Double = 0.0
    var total: Double = 0.0
    var tax: Double = 0.0
    var discount: Double = 0.0
    var productId: Int = 0
    var packageId: Int = 0
    var selectedProductAttribute: [Attributes] = []
    var itemType: String = ""
    var productitem: Product? = nil
    var packageitem: Package? = nil

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                       <- map["id"]
        productQuantity          <- map["productQuantity"]
        packageQuantity          <- map["packageQuantity"]
        price                    <- map["price"]
        total                    <- map["total"]
        tax                      <- map["tax"]
        discount                 <- map["discount"]
        productId                <- map["productId"]
        packageId                <- map["packageId"]
        selectedProductAttribute <- map["selectedProductAttribute"]
        itemType                 <- map["itemType"]
        productitem              <- map["productitem"]
        packageitem              <- map["packageitem"]
    }
    
}
