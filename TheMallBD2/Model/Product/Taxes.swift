import ObjectMapper

class Taxes: Mappable {
    
    var id:Int = 0
    var title:String = ""
    var type:Shop!
    var amount:Double = 0
    var createdOn:String=""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id               <- map["id"]
        title            <- map["title"]
        type             <- map["type"]
        amount           <- map["amount"]
        createdOn        <- map["createdOn"]
        
    }

}
