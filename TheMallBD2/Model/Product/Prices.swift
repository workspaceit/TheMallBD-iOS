import ObjectMapper

class Prices: Mappable {
    
    var id:Int = 0
    var tax:Taxes!
    var purchasePrice: Double = 0
    var wholesalePrice: Double = 0
    var retailPrice: Double = 0
    var createdOn:String=""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                <- map["id"]
        tax               <- map["tax"]
        purchasePrice     <- map["purchasePrice"]
        wholesalePrice    <- map["wholesalePrice"]
        retailPrice       <- map["retailPrice"]
        createdOn         <- map["createdOn"]
        
    }

}
