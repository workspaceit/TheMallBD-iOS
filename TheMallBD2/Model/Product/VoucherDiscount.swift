import ObjectMapper

class VoucherDiscount: Mappable {
    
    var discount: Double = 0.0
    var voucherCode: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        voucherCode     <- map["voucher_code"]
        discount        <- map["discount"]
    }
}
