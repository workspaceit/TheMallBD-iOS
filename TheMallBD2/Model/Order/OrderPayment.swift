import ObjectMapper

class OrderPayment: Mappable {

    var id: Int?
    var orderId: Int?
    var paymentTotal: Double = 0.0
    var paymentDetails: String = ""
    var paymentStatus: String = ""
    var createdOn: String = ""
    var createdBy: String = ""
    var updatedOn: String = ""
    var updatedBy: String? = nil
    var paymentMethod: PaymentMethod? = nil

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        orderId         <- map["orderId"]
        paymentTotal    <- map["paymentTotal"]
        paymentDetails  <- map["paymentDetails"]
        paymentStatus   <- map["paymentStatus"]
        createdOn       <- map["createdOn"]
        createdBy       <- map["createdBy"]
        updatedOn       <- map["updatedOn"]
        updatedBy       <- map["updatedBy"]
        paymentMethod   <- map["paymentMethod"]
    }
    
}
