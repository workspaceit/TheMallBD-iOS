import ObjectMapper

class PaymentMethod: Mappable {
    
    var id: Int = 0
    var methodTitle: String?
    var description: String?
    var icon: String?
    var createdOn: String?
    var createdBy: String?
    var updatedOn: String?
    var updatedBy: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        methodTitle     <- map["methodTitle"]
        description     <- map["description"]
        icon            <- map["icon"]
        createdOn       <- map["createdOn"]
        createdBy       <- map["createdBy"]
        updatedOn       <- map["updatedOn"]
        updatedBy       <- map["updatedBy"]
    }
    
}
