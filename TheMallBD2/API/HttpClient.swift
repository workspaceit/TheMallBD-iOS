import UIKit
import Alamofire
import KVNProgress

class HttpClient: NSObject {
    
    class func showLoader(_ message: String, showLoader: Bool) {
        if showLoader {
            KVNProgress.show(withStatus: message)
        }
    }
    
    class func hideLoader(_ hideLoader: Bool) {
        if hideLoader {
            KVNProgress.dismiss()
        }
    }
    
    class func setCookie(_ cookie:HTTPCookie){
        print("set cookie")
        UserDefaults.standard.set(cookie.properties, forKey: "kCookie")
        UserDefaults.standard.synchronize()
    }
    
    class func getCookie() -> HTTPCookie{
        print("get cookie")
        let cookie = HTTPCookie(properties: UserDefaults.standard.object(forKey: "kCookie")  as! [HTTPCookiePropertyKey : Any])
        print(cookie!)
        return cookie!
    }
    
    class func getRequest(_ url:String,param:[String: AnyObject]? = nil, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ result: AnyObject) -> Void) {
        HttpClient.showLoader("", showLoader: showLoader)
        print(Constants.baseUrl + url)
        Alamofire.request(Constants.baseUrl+url, method: .get, parameters:param)
            .responseJSON { response in
                switch response.result {
                case .success:
                    HttpClient.hideLoader(showLoader)
                    onCompletion(response.result.value! as AnyObject)
                case .failure(let error):
                    HttpClient.hideLoader(showLoader)
                    KVNProgress.dismiss()
                    print(error)
                    if error._code == -1004 {
                        print("No internet")
                    }
                    handleError(error: error as AnyObject, currentView: view)
                }
        }
        
    }
    
    class func postRequest(_ url:String,param:[String: AnyObject]? = nil,showLoader: Bool, view: UIView?, onCompletion: @escaping (_ result: AnyObject?) -> Void) {
        HttpClient.showLoader("", showLoader: showLoader)
        print(Constants.baseUrl+url)
        Alamofire.request(Constants.baseUrl+url, method: .post, parameters:param)
            .responseJSON { response in
                switch response.result {
                    case .success:
                        if url == "login" || url == "api/login/accesstoken" {
                            print("setting  .......")
                            let cookies = HTTPCookie.cookies(withResponseHeaderFields: response.response?.allHeaderFields as! [String: String], for: (response.response?.url!)!)
                            HttpClient.setCookie(cookies.first!)
                        }
                        HttpClient.hideLoader(showLoader)
                        onCompletion(response.result.value! as AnyObject?)
                    case .failure(let error):
                        HttpClient.hideLoader(showLoader)
                    handleError(error: error as AnyObject, currentView: view!)
                }
        }
        
    }
    
    class func postRequest1(_ url:String,param:[String: AnyObject]? = nil,showLoader: Bool, view: UIView, onCompletion: @escaping (_ result: AnyObject) -> Void) {
        HttpClient.showLoader("", showLoader: showLoader)
        print(Constants.baseUrl+url)
        Alamofire.request(Constants.baseUrl+url, method: .post, parameters:param)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success:
                    HttpClient.hideLoader(showLoader)
                    onCompletion(response.result.value! as AnyObject)
                case .failure(let error):
                    HttpClient.hideLoader(showLoader)
//                    print(error._code)
//                    if error._code == -1004 {
//                        print("No internet")
//                    }
                    handleError(error: error as AnyObject, currentView: view)
                }
        }
        
    }
    
    
    class func handleError(error: AnyObject, currentView: UIView?) {
        var message = ""
        if !Utility.online {
            message = "The Internet connection appears to be offline"
        }
        else {
            message = "Something went wrong. Plase try again."
        }
        if currentView != nil {
            currentView?.makeToast(message: message)
        }
    }
  
}
