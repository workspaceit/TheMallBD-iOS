import ObjectMapper

class District: Mappable {
    
    var name: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name    <-  map["name"]
    }
    
}
