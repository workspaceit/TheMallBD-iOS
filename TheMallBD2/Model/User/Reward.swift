import ObjectMapper

class Reward: Mappable {
    
    var id:Int = 1
    var user:User!
//  var order:Order
    var description:String = ""
    var points:String = ""
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        user         <- map["user"]
    //  order      <- map["order"]
        description    <- map["description"]
        points         <- map["points"]
        createdOn      <- map["createdOn"]
        
    }

}
