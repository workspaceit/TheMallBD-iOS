import ObjectMapper


class AuthCredential: AppCredential {

    var accessToken:String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        accessToken    <- map["accessToken"]
        
    }
}
