import ObjectMapper

class Tag: Mappable {
    
    var id:Int = 0
    var title:String = ""
    var shop:Shop!
    var createdOn:String=""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id               <- map["id"]
        title            <- map["title"]
        shop             <- map["shop"]
        createdOn        <- map["createdOn"]
        
    }

}
