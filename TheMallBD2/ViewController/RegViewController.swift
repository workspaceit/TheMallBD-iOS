import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class RegViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeField: UITextField? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
        self.fName.delegate = self
        self.lName.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.confirmPassword.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(RegViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let topLength = self.parent?.topLayoutGuide.length
        let bottomLength = self.parent?.bottomLayoutGuide.length
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(topLength!, 0.0, bottomLength! + (keyboardSize?.height)! + 120, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        
        aRect.size.height -= ((keyboardSize?.height)! + 120 + bottomLength!)
        print(aRect)
        if activeField != nil {
            print(activeField!)
            print("inside not null 00")
            self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            if (!aRect.contains(activeField!.frame.origin)){
                print("inside not null")
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("activated")
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    @IBAction func register(_ sender: AnyObject) {
        let firstName = fName.text
        let lastName = lName.text
        let emailString = email.text
        let phoneString = phone.text
        let pass = password.text
        let confirmPass = confirmPassword.text
        var formIsValid = true
        
        if firstName?.characters.count == 0 {
            formIsValid = false
            Utility.showValidationError("Error", message: "First name can't be blank.", viewController: self)
        }
        else if lastName?.characters.count == 0 {
            formIsValid = false
            Utility.showValidationError("Error", message: "Last name can't be blank.", viewController: self)
        }
        else if emailString?.characters.count == 0 {
            formIsValid = false
            Utility.showValidationError("Error", message: "Email can't be blank.", viewController: self)
        }
        else if !isEmailValid(emailString!) {
            formIsValid = false
            Utility.showValidationError("Error", message: "Email is not valid.", viewController: self)
        }
        else if phoneString?.characters.count < 11 {
            formIsValid = false
            Utility.showValidationError("Error", message: "Phone number must be of 11 digits.", viewController: self)
        }
        else if pass?.characters.count < 6 {
            formIsValid = false
            Utility.showValidationError("Error", message: "Password can't be blank.", viewController: self)
        }
        else if pass != confirmPass {
            formIsValid = false
            Utility.showValidationError("Error", message: "Passwords don't match.", viewController: self)
        }
       
        
        if formIsValid {
            ServiceProvider.register(firstName!, lastname: lastName!, phone: phoneString!, email: emailString!, password: pass!, confirmPassword: confirmPass!, showLoader: true, view: self.view) { (response: NSDictionary) in
                let responseStat = response["responseStat"] as! NSDictionary
                if (responseStat["status"] as? Int == 1) {
                    let responseData = response["responseData"] as! NSDictionary
                    let accesskey: String! = responseData["accesskey"] as? String
                    let defaults = UserDefaults.standard
                    defaults.set(accesskey, forKey: "accesskey")
                    Utility.showValidationError("Success", message: responseStat["msg"] as! String, viewController: self)
                }
                else {
                    Utility.showValidationError("Error", message: responseStat["msg"] as! String, viewController: self)
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
