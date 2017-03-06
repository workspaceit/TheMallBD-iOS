import ObjectMapper

class Product: Mappable {
    
    var id:Int = 0
    var code:String = ""
    var shop:Shop!
    var supplier:Suppliers!
    var wearhouse:Warehouse!
    var manufacturer:Manufacturer!
    var prices:[Prices]!
    var discount:[Discount]!
    var categories:[Categories]!
    var tags:[Tag]!
    var reviews:[Review]!
    var pictures:[Picture]!
    var attributes:[Attributes]!
    var isFeatured:Bool = false
    var title:String=""
    var description:String=""
    var url:String=""
    var barCode:String=""
    var width:String=""
    var height:String=""
    var depth:String=""
    var wight:String=""
    var quantity: String = "0"
    var status:Int=0
    var metaTitle:String=""
    var metaDescription:String=""
    var expireDate:String=""
    var menufacturedDate:String=""
    var createdOn:String=""
    var productDescriptionMobile: String = ""
    var discountActiveFlag: Bool = false
    var discountAmount: Double = 0
    var point: Int = 0
    var minimumOrderQuantity: Int = 1
    
    var avgRating: Float = 10
    
    init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        code                        <- map["code"]
        shop                        <- map["shop"]
        supplier                    <- map["supplier"]
        wearhouse                   <- map["wearhouse"]
        manufacturer                <- map["manufacturer"]
        prices                      <- map["prices"]
        discount                    <- map["discount"]
        categories                  <- map["categories"]
        tags                        <- map["tags"]
        reviews                     <- map["reviews"]
        pictures                    <- map["pictures"]
        attributes                  <- map["attributes"]
        isFeatured                  <- map["isFeatured"]
        title                       <- map["title"]
        description                 <- map["description"]
        url                         <- map["url"]
        barCode                     <- map["barCode"]
        width                       <- map["width"]
        height                      <- map["height"]
        depth                       <- map["depth"]
        wight                       <- map["wight"]
        quantity                    <- map["quantity"]
        status                      <- map["status"]
        metaTitle                   <- map["metaTitle"]
        metaDescription             <- map["metaDescription"]
        expireDate                  <- map["expireDate"]
        menufacturedDate            <- map["menufacturedDate"]
        createdOn                   <- map["createdOn"]
        productDescriptionMobile    <- map["productDescriptionMobile"]
        discountActiveFlag          <- map["discountActiveFlag"]
        discountAmount              <- map["discountAmount"]
        avgRating                   <- map["avgRating"]
        point                       <- map["point"]
        minimumOrderQuantity        <- (map["minimumOrderQuantity"], TransformOf<Int, String>(fromJSON: { Int($0!) }, toJSON: { $0.map { String($0) } }))
    }

}
