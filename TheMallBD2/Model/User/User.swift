import ObjectMapper

class User: Mappable {
    
    var id:Int = 0
    var email: String = ""
    var firstName:String = ""
    var lastName:String = ""
    var phone:String = ""
    var image:String = ""
    var role:Role?
    var details:UserDetails!
    var wishlist:[Wishlist]!
    var status:String = ""
    var createdOn:String=""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        email           <- map["email"]
        firstName       <- map["firstName"]
        lastName        <- map["lastName"]
        phone           <- map["phone"]
        image           <- map["image"]
        role            <- map["role"]
        details         <- map["userDetails"]
        wishlist        <- map["wishlist"]
        createdOn       <- map["createdOn"]
        
    }

}
