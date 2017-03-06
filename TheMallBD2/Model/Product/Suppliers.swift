import ObjectMapper

class Suppliers: Mappable {
    
    var id:Int = 0
    var name:String = ""
    var code:String = ""
    var phone:String = ""
    var email:String = ""
    var contactPerson:String = ""
    var address:Address!
    var manager:User!
    var createdOn:String=""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        name         <- map["name"]
        code         <- map["code"]
        phone         <- map["phone"]
        email         <- map["email"]
        manager         <- map["manager"]
        contactPerson   <- map["contactPerson"]
        address         <- map["address"]
        manager         <- map["manager"]
        createdOn      <- map["createdOn"]
        
    }

}
