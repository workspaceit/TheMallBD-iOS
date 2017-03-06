import ObjectMapper

class SelectedAttribute: Mappable {
    
    var id = 0
    var name = ""
    var value = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id      <- map["id"]
        name    <- map["name"]
        value   <- map["value"]
    }
    
}
