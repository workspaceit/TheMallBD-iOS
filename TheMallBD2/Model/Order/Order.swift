import ObjectMapper

class Order: Mappable {

    var id: Int = 0
    var shopId: Int = 1
    var zoneId = 1
    var invoiceNo: String = ""
    var currencyCode: String = ""
    var currencyValue: String = ""
    var orderTotal: Double = 0.0
    var orderFrom: String = ""
    var voucher_discount: Double = 0.0
    var discount_totalP: Double = 0.0
    var shipping_cost: Double = 0.0
    var employee_discount: Double = 0.0
    var special_discount: Double = 0.0
    var packageSize: String = ""
    var packageWeight: String = ""
    var shippingAddress: String = ""
    var shippingCountry: String = ""
    var shippingZipCode: String = ""
    var orderDate: String = ""
    var isWrapped: String = ""
    var wrappedNote: String = ""
    var createdOn: String = ""
    var createdBy: Int = 0
    var updatedOn: String = ""
    var updatedBy: Int = 0
    var totalQuantity: Int = 0
    var shop: Shop? = nil
    var currency: Currency? = nil
    var zone: Zone? = nil
    var orderpayments: [OrderPayment] = []
    var orderProducts: [OrderProduct] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        shopId              <- map["shopId"]
        zoneId              <- map["zoneId"]
        invoiceNo           <- map["invoiceNo"]
        currencyCode        <- map["currencyCode"]
        currencyValue       <- map["currencyValue"]
        orderTotal          <- map["orderTotal"]
        orderFrom           <- map["orderFrom"]
        voucher_discount    <- map["voucher_discount"]
        discount_totalP     <- map["discount_totalP"]
        shipping_cost       <- map["shipping_cost"]
        employee_discount   <- map["employee_discount"]
        special_discount    <- map["special_discount"]
        packageSize         <- map["packageSize"]
        packageWeight       <- map["packageWeight"]
        shippingAddress     <- map["shippingAddress"]
        shippingCountry     <- map["shippingCountry"]
        shippingZipCode     <- map["shippingZipCode"]
        orderDate           <- map["orderDate"]
        isWrapped           <- map["isWrapped"]
        wrappedNote         <- map["wrappedNote"]
        createdOn           <- map["createdOn"]
        createdBy           <- map["createdBy"]
        updatedOn           <- map["updatedOn"]
        updatedBy           <- map["updatedBy"]
        totalQuantity       <- map["totalQuantity"]
        shop                <- map["shop"]
//        currency            <- map["currency"]
//        zone                <- map["zone"]
        orderpayments       <- map["orderpayments"]
        orderProducts       <- map["orderProducts"]
    }
    
}
