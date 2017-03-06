import ObjectMapper

class Shop: Mappable {
    
    var id:Int = 0
    var name:String = ""
    var description:String = ""
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        name         <- map["name"]
        description      <- map["description"]
        createdOn      <- map["createdOn"]
        
    }

}
