import ObjectMapper

class AppCredential: Mappable {

    var id:Int = 0
    var email:String = ""
    var user:User!
    var createdOn:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        email         <- map["email"]
        user         <- map["user"]
        createdOn      <- map["createdOn"]
        
    }
}
