import ObjectMapper

class Categories: Mappable {
    
    var id:Int = 0
    var title:String = ""
    var shop:Shop!
    var icon:String = ""
    var banner:String = ""
    var metaTitle:String = ""
    var metaDescription:Address?
    var createdOn:String=""
    var childrens:[Categories]!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id               <- map["id"]
        title            <- map["title"]
        shop             <- map["shop"]
        childrens        <- map["childrens"]
        icon             <- map["icon"]
        banner           <- map["banner"]
        metaTitle        <- map["metaTitle"]
        metaDescription  <- map["metaDescription"]
        createdOn        <- map["createdOn"]
    }

}
