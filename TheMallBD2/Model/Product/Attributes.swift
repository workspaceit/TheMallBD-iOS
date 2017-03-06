import ObjectMapper

class Attributes: Mappable {
    
    var id:Int = 0
    var name:String = ""
    var values:AttributesValue!
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        name         <- map["name"]
        values         <- map["values"]
        createdOn      <- map["createdOn"]
        
    }

}
