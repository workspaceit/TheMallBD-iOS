import ObjectMapper

class CartProductCell: Mappable {
    var id: Int = 0
    var product: Product!
    var quantity: Int = 0
    var selectedAttributes: [SelectedAttribute] = []

    
    init(id: Int, product: Product, quantity: Int){
        self.id = id
        self.product = product
        self.quantity = quantity
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        product         <- map["product"]
        quantity        <- map["quantity"]
        selectedAttributes  <- map["selectedAttributes"]
    }
    
}
