import ObjectMapper

class Payment: Mappable {
    
    var bkashCharge: Double = 0.0
    var invoiceNo: String = ""
    var orderGrandTotal: Double = 0.0
    var orderId: Int = 0
    var paypalPayAmount: Double = 0.0
    var totalBkashPay: Double = 0.0
    var uniqueCode: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        bkashCharge         <- map["bkash_charge"]
        invoiceNo           <- map["invoice_no"]
        orderGrandTotal     <- map["order_grand_total"]
        orderId             <- map["order_id"]
        paypalPayAmount     <- map["paypal_pay_amount"]
        totalBkashPay       <- map["total_bkash_pay"]
        uniqueCode          <- map["unique_code"]
    }
    
}
