import ObjectMapper

class Package: Mappable {
    
    var id: Int = 0
    var packageTitle: String = ""
    var desc: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var image: String = ""
    var originalPriceTotal: Float = 0
    var packagePriceTotal: Float = 0
    var status: String = ""
    var createdOn: String = ""
    var packageDescription: String = ""
    var packageProducts: [PackageProduct] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        packageTitle <-  map["packageTitle"]
        desc <-  map["description"]
        startDate <-  map["startDate"]
        endDate <-  map["endDate"]
        image <-  map["image"]
        originalPriceTotal <-  map["originalPriceTotal"]
        packagePriceTotal <-  map["packagePriceTotal"]
        status <-  map["status"]
        createdOn <- map["createdOn"]
        packageDescription <- map["description"]
        packageProducts <- map["packageProduct"]
    }
    
}
