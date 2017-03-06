import UIKit
import ObjectMapper
import Alamofire

class Utility: NSObject {
    
    static var shoppingCart: ShoppingCart = ShoppingCart()
    static var categories: [Categories] = []
    static var loggedIn = false
    static var newProducts: [Product] = []
    static var featuredProducts: [Product] = []
    static var discountProducts: [Product] = []
    static var user: User!
    static var online = true
    
    class func clearCart() {
        Utility.shoppingCart = ShoppingCart()
    }
    
    class func clearUser() {
        Utility.loggedIn = false
        Utility.user = nil
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user")
        defaults.removeObject(forKey: "accessToken")
    }
    
    class func updateUser(_ user1: User){
        Utility.user = user1
        Utility.storeUser()
    }
    
    class func storeUser(){
        let userJsonString = Mapper().toJSONString(Utility.user, prettyPrint: false)
        let defaults = UserDefaults.standard
        defaults.set(userJsonString, forKey: "user")
    }
    
    class func networkReachability() {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            if (manager?.isReachable)! {
                online = true
            }
            else {
                online = false
            }
            print("isOnline: \(online)")
        }
        manager?.startListening()
        if (manager?.isReachable)! {
            online = true
        }
        else {
            online = false
        }
        print("isOnline: \(online)")
    }
    
    class func loginByAccessKey2(view: UIView, onCompletion: @escaping (_ success: Bool) -> Void) {
        let defaults = UserDefaults.standard
        let accessToken = defaults.object(forKey: "accessToken")
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                
            }
            if accessToken != nil {
//                topController.view.makeToast(message: accessToken as! String)
            }
        }
        
        if accessToken != nil {
            let token: String! = accessToken as! String
            ServiceProvider.loginWithAccessKey2(token: token, showLoader: false, view: view) { (loginResponse: LoginResponse) in
                if (loginResponse.responseStat.status!) {
                    print("inside out")
                    let defaults = UserDefaults.standard
                    let accesskey: String! = loginResponse.responseData.accesstoken
                    let user: User = loginResponse.responseData.user!
                    let userJsonString = Mapper().toJSONString(user, prettyPrint: false)
//                    defaults.set(userJsonString, forKey: "cart")
                    defaults.set(accesskey, forKey: "accessToken")
                    defaults.set(userJsonString, forKey: "user")
                    Utility.loggedIn = true
                    Utility.user = user
                    onCompletion(true)
                    
                }
                else {
                    onCompletion(false)
                }
            }
        }
        else {
            onCompletion(false)
        }
        
    }
    
    class func loginByAccessKey(view: UIView) {
        networkReachability()
    
        let defaults = UserDefaults.standard
        let accessToken = defaults.object(forKey: "accessToken")
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                
            }
            if accessToken != nil {
                topController.view.makeToast(message: accessToken as! String)
            }
        }
        
        if accessToken != nil {
            let token: String! = accessToken as! String
            ServiceProvider.loginWithAccessKey(token: token, showLoader: false, view: view) { (response: UserInfo) in
                let defaults = UserDefaults.standard
                let accesskey: String! = response.accesstoken
                let user: User! = response.user!
                HTTPCookieStorage.shared.setCookie(HttpClient.getCookie())
                let userJsonString = Mapper().toJSONString(user, prettyPrint: false)
                print(userJsonString!)
                defaults.set(userJsonString, forKey: "cart")
                
                defaults.set(accesskey, forKey: "accessToken")
                defaults.set(userJsonString, forKey: "user")
                
                Utility.loggedIn = true
                Utility.user = user
            }
        }
    }
    
    class func setCartFromStorage(vc: UIViewController){
        let defaults = UserDefaults.standard
        let cartString = defaults.object(forKey: "cart")
        if cartString != nil {
            let cart = Mapper<ShoppingCart>().map(JSONString: cartString as! String)
            shoppingCart = cart!
        }
        let userJsonString = defaults.object(forKey: "user")
        if userJsonString != nil {
            Utility.loggedIn = true
            self.user = Mapper<User>().map(JSONString: userJsonString as! String)
        }
        
        let cartItemCount = Utility.shoppingCart.mallBdPackageCell.count + Utility.shoppingCart.productCell.count
        var badge: String? = nil
        if cartItemCount > 0 {
            badge = String(cartItemCount)
        }
        vc.tabBarController?.tabBar.items?[1].badgeValue = badge
        
    }
    
    class func showValidationError(_ title: String, message: String, viewController: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = UIColor(netHex: 0xAE1522)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            print("OK button tapped")
        })
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func isEmailValid(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
