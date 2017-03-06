import ObjectMapper

class Review: Mappable {
    
    var id:Int = 0
    var customer:User!
    var note:String = ""
    var rating:String = "0"
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        customer        <- map["customer"]
        note            <- map["note"]
        rating          <- map["rating"]
        createdOn       <- map["createdOn"]
    }

}
