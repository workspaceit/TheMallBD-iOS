import ObjectMapper

class Manufacturer: Mappable {
    
    var id: Int!
    var name:String = ""
    var icon:String = ""
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        icon        <- map["icon"]
        createdOn   <- map["createdOn"]
    }

}
