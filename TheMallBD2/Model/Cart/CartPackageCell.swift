import ObjectMapper

class CartPackageCell: Mappable {
    var id: Int = 0
    var mallBdPackage: Package!
    var quantity: Int = 0
    
    init(id: Int, package: Package, quantity: Int){
        self.id = id
        self.mallBdPackage = package
        self.quantity = quantity
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        mallBdPackage   <- map["mallBdPackage"]
        quantity        <- map["quantity"]
    }
}
