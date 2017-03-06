import ObjectMapper

class ShoppingCart: Mappable {
    
    var productCell: [CartProductCell] = []
    var mallBdPackageCell: [CartPackageCell] = []
    var orderTotal: Double = 0.0
    var productDiscountTotal: Double = 0
    var shippingCost: Double = 0
    var totalDiscount: Double = 0
    var totalPrice: Double = 0.0
    var totalTax: Double = 0
    var voucherDiscount: Double = 0
    var id = 1
    
   
    required convenience init?(map: Map) {
        self.init()
    }
    
    
    func mapping(map: Map) {
        productCell             <- map["productCell"]
        mallBdPackageCell       <- map["mallBdPackageCell"]
        orderTotal              <- map["orderTotal"]
        productDiscountTotal    <- map["productDiscountTotal"]
        shippingCost            <- map["shippingCost"]
        totalDiscount           <- map["totalDiscount"]
        totalPrice              <- map["totalPrice"]
        totalTax                <- map["totalTax"]
        voucherDiscount         <- map["voucherDiscount"]
    }
    
    func update(){
        var totalProductPrice: Double = 0.0
        var totalPackagePrice: Double = 0.0
        var totalProductDiscount: Double = 0.0
        for proCell in self.productCell {
            let product = proCell.product
            let prices = product?.prices
            if (prices?.count)! > 0 {
                let priceObj = prices?[0]
                let prp = priceObj?.retailPrice
                let discount = product?.discountAmount
                if (product?.discountActiveFlag)! {
                    let currentPrice = prp! - discount!
                    totalProductPrice += Double(proCell.quantity) * currentPrice
                    totalProductDiscount += discount!
                }
                else {
                    totalProductPrice += Double(proCell.quantity) * prp!
                }
            }
        }
        for packCell in self.mallBdPackageCell {
            let package = packCell.mallBdPackage
            let price = package?.packagePriceTotal
            totalPackagePrice += Double(price!) * Double(packCell.quantity)
        }
        totalPrice = totalProductPrice + totalPackagePrice
        orderTotal = totalPrice + shippingCost + totalTax
        self.productDiscountTotal = totalProductDiscount
        totalDiscount = totalProductDiscount + voucherDiscount
//        orderTotal = totalProductPrice + totalPackagePrice + shippingCost + totalTax - totalDiscount
//        orderTotal = totalProductPrice + totalPackagePrice
        orderTotal = totalProductPrice + totalPackagePrice + shippingCost + totalTax - totalDiscount
        
//        print("orderTotal\(orderTotal)")
//        print("productDiscountTotal\(productDiscountTotal)")
//        print("totalDiscount\(totalDiscount)")
//        print("totalPrice\(totalPrice)")
        
        saveOnLocalStorage()
    }
    
    func saveOnLocalStorage() {
        let cartString = Mapper().toJSONString(self, prettyPrint: true)
        let defaults = UserDefaults.standard
        defaults.set(cartString, forKey: "cart")
    }
    
    func clear(){
        productCell = []
        mallBdPackageCell = []
        orderTotal = 0
        productDiscountTotal = 0
        shippingCost = 0
        totalDiscount = 0
        totalPrice = 0
        totalTax = 0
        voucherDiscount = 0
    }
    
}
