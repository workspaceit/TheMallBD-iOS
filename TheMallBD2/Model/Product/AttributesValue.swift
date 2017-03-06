import ObjectMapper

class AttributesValue: Mappable {
    
    var id:Int = 0
    var name:String = ""
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        name         <- map["name"]
        createdOn      <- map["createdOn"]
        
    }

}
