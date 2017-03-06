import ObjectMapper

class Discount: Mappable {
    
    var id:Int = 0
    var title:String = ""
    var type:Shop!
    var amount:Double = 0
    var startDate:String=""
    var endDate:String=""
    var createdOn:String=""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id               <- map["id"]
        title            <- map["title"]
        type             <- map["type"]
        amount           <- map["amount"]
        startDate        <- map["startDate"]
        endDate          <- map["endDate"]
        createdOn        <- map["createdOn"]
        
    }

}
