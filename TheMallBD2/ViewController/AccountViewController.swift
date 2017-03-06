import UIKit
import DropDown

class AccountViewController: UIViewController ,UIGestureRecognizerDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var zip: UITextField!
    var editMode = false
    @IBOutlet weak var countryDropdown: UIView!
    var dropdown = DropDown()
    var countries: [String] = []
    
    @IBOutlet weak var countryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.setHidesBackButton(true, animated:true)
        retrieveCountries()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AccountViewController.showDropDown))
        tapGesture.delegate = self
        self.countryDropdown.addGestureRecognizer(tapGesture)
    }
    
    func showDropDown() {
        if editMode {
            dropdown.show() 
        }
    }
    
    func retrieveCountries() {
        for code in Locale.isoRegionCodes as [String] {
            let id = Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = (Locale(identifier: "en_US") as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        self.dropdown.anchorView = countryDropdown
        self.dropdown.dataSource = countries
        self.dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.countryLabel.text = item
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        email.text = ""
        firstName.text = ""
        lastName.text = ""
        phone.text = ""
        address.text = ""
        city.text = ""
        zip.text = ""
        countryLabel.text = ""
        initialize()
    }
    
    func initialize(){
        email.text = Utility.user.email
        firstName.text = Utility.user.firstName
        lastName.text = Utility.user.lastName
        phone.text = Utility.user.phone
        address.text = Utility.user!.details!.address!.address
        city.text = Utility.user.details.address.city
        zip.text = Utility.user.details.address.zipcode
        var country = Utility.user.details.address.country
        if country == "" {
            country = "Bangladesh"
        }
        countryLabel.text = country
    }
    
    func toggleMode(){
        editMode = !editMode
        email.isUserInteractionEnabled = editMode
        email.isUserInteractionEnabled = editMode
        firstName.isUserInteractionEnabled = editMode
        lastName.isUserInteractionEnabled = editMode
        phone.isUserInteractionEnabled = editMode
        address.isUserInteractionEnabled = editMode
        city.isUserInteractionEnabled = editMode
        zip.isUserInteractionEnabled = editMode
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if editMode {
            let userFirstName = firstName.text
            let userLastName = lastName.text
            let userPhone = phone.text
            let userAddress = address.text
            let userCity = city.text
            let userZip = zip.text
            let userCountry = countryLabel.text
            ServiceProvider.updateAccountInfo(userFirstName!, lastName: userLastName!, phone: userPhone!, address: userAddress!, city: userCity!, zip: userZip!, country: userCountry!, showLoader: true, view: self.view){ (userInfo: UserInfo?) in
                if userInfo != nil {
                    Utility.updateUser(userInfo!.user)
                    self.initialize()
                    self.view.makeToast(message: "Account Updated")
                    self.toggleMode()
                    sender.setTitle("Edit", for: UIControlState())
                }
                else {
                    self.initialize()
                }
            }
        }
        else {
            sender.setTitle("Update", for: UIControlState())
            self.toggleMode()
        }
    }
    
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        dismissKeyboard()
        if editMode {
            let userFirstName = firstName.text
            let userLastName = lastName.text
            let userPhone = phone.text
            let userAddress = address.text
            let userCity = city.text
            let userZip = zip.text
            let userCountry = countryLabel.text
            ServiceProvider.updateAccountInfo(userFirstName!, lastName: userLastName!, phone: userPhone!, address: userAddress!, city: userCity!, zip: userZip!, country: userCountry!, showLoader: true, view: self.view){ (userInfo: UserInfo?) in
                if userInfo != nil {
                    sender.title = "Edit"
                    Utility.updateUser(userInfo!.user)
                    self.initialize()
                    self.view.makeToast(message: "Account Updated")
                    self.toggleMode()
                    
                }
                else {
                    self.initialize()
                }
            }
        }
        else {
            sender.title = "Done"
            self.toggleMode()
        }
    }
    

}
