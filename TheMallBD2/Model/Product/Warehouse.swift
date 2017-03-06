import ObjectMapper

class Warehouse: Mappable {

    var id:Int = 0
    var name:String = ""
    var code:String = ""
    var address:Address!
    var zone:Zone!
    var manager:User!
    var status:String = ""
    var createdOn:String=""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        name         <- map["name"]
        code         <- map["code"]
        address         <- map["address"]
        zone         <- map["zone"]
        manager         <- map["manager"]
        status         <- map["status"]
        createdOn      <- map["createdOn"]
        
    }
}
