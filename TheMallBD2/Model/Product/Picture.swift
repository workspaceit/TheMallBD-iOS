import ObjectMapper

class Picture: Mappable {
    
    
    var id:Int = 0
    var name:String = ""
    var caption:String = ""
    var position:String = ""
    var cover:Bool = false
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id           <- map["id"]
        name         <- map["name"]
        caption      <- map["caption"]
        position     <- map["position"]
        cover        <- map["cover"]
        createdOn    <- map["createdOn"]
        
    }

}
