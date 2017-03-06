import ObjectMapper

class CustomerPurchaseDiscount: Mappable {
    
    var id: Int? = nil
    var discount_base: String = ""
    var discount_base_limit: Double = 0
    var discount_type: String = ""
    var discount_amount: Double = 0
    var createdOn: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                      <- map["id"]
        discount_base           <- map["discount_base"]
        discount_base_limit     <- (map["discount_base_limit"], TransformOf<Double, String>(fromJSON: { Double($0!) }, toJSON: { $0.map { String($0) } }))
        discount_type           <- map["discount_type"]
        discount_amount         <- (map["discount_amount"], TransformOf<Double, String>(fromJSON: { Double($0!) }, toJSON: { $0.map { String($0) } }))
        createdOn               <- map["createdOn"]
    }

}
