import UIKit
import ObjectMapper

class LoginController2: UIViewController {

    @IBOutlet weak var emailoField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var tabBarC: UITabBarController? = nil
    var toIndex = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func login(_ sender: AnyObject) {
        
        let email = emailoField!.text
        let password = passwordField.text
        var valid: Bool = true
        
        if email?.characters.count == 0 {
            valid = false
            Utility.showValidationError("Error", message: "Email can't be blank", viewController: self)
        }
        else if (!isEmailValid(email!)){
            valid = false
            Utility.showValidationError("Error", message: "Email is not valid.", viewController: self)
        }
        else if password?.characters.count == 0 {
            valid = false
             Utility.showValidationError("Error", message: "Password can't be blank", viewController: self)
        }
        if valid {
            ServiceProvider.login(email!, password: password!, showLoader: true, view: self.view) { (loginResponse: LoginResponse ) in
                print(loginResponse)
                if loginResponse.responseStat.status! {
                    print("inside out")
                    let accesskey: String! = loginResponse.responseData.accesstoken
                    let user: User = loginResponse.responseData.user!
                    let userJsonString = Mapper().toJSONString(user, prettyPrint: false)
                    let defaults = UserDefaults.standard
                    defaults.set(accesskey, forKey: "accessToken")
                    defaults.set(userJsonString, forKey: "user")
                    Utility.loggedIn = true
                    Utility.user = user
//                    Utility.showValidationError("Success", message: response["responseStat"]!["msg"] as! String, viewController: self)
                    self.view.makeToast(message: "You are now logged in")
                    self.dismiss(animated: true, completion: nil)
                    self.tabBarC?.selectedIndex = self.toIndex
                }
                else {
                    Utility.showValidationError("Error", message: loginResponse.responseStat.msg!, viewController: self)
                }
            }
        }
    }
    
    func isEmailValid(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
