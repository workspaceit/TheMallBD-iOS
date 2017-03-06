import ObjectMapper

class Checkout: Mappable {
    
    var first_name: String = ""
    var last_name: String = ""
    var email: String = ""
    var phone: String = ""
    var address: String = ""
    var city: String = ""
    
    var order_from = "IOS"
    
    var invoice_address: Bool = false
    var shipping_firstname: String = ""
    var shipping_lastname: String = ""
    var shipping_phone: String = ""
    var shipping_address = ""
    var shipping_city = ""
    
    var delivery_method_id: Int?
    var payment_method_id: Int?
    var currency_id: Int?
    
    var voucherDiscountDetails: [VoucherDiscount] = []
    var customerDiscount: Double = 0
    var customerDiscountDetails: CustomerPurchaseDiscount? = nil
    
    var shopping_cart: ShoppingCart? = nil
    
    
    required init() {
        self.first_name = ""
        self.last_name = ""
        self.email = ""
        self.phone = ""
        self.address = ""
        self.city = ""
        
        self.order_from = "IOS"
        
        self.invoice_address = false
        self.shipping_firstname = ""
        self.shipping_lastname = ""
        self.shipping_phone = ""
        self.shipping_address = ""
        self.shipping_city = ""
        
        self.delivery_method_id = nil
        self.payment_method_id = nil
        self.currency_id = nil
        
        
        self.voucherDiscountDetails = []
        self.customerDiscount = 0.0
        self.customerDiscountDetails = nil
        
        self.shopping_cart = nil
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        first_name              <- map["first_name"]
        last_name               <- map["last_name"]
        email                   <- map["email"]
        phone                   <- map["phone"]
        address                 <- map["address"]
        city                    <- map["city"]
        
        order_from              <- map["order_from"]
        
        invoice_address         <- map["invoice_address"]
        shipping_firstname      <- map["shipping_firstname"]
        shipping_lastname       <- map["shipping_lastname"]
        shipping_phone          <- map["shipping_phone"]
        shipping_address        <- map["shipping_address"]
        shipping_city           <- map["shipping_city"]
        
        delivery_method_id      <- map["delivery_method_id"]
        payment_method_id       <- map["payment_method_id"]
        currency_id             <- map["currency_id"]
        
        voucherDiscountDetails  <- map["voucherDiscountDetails"]
        customerDiscount        <- map["customerDiscount"]
        customerDiscountDetails <- map["customerDiscountDetails"]
        invoice_address         <- map["invoice_address"]
        
        shopping_cart           <- map["shopping_cart"]
        
    }
    
}
