import UIKit
import KVNProgress
import DropDown

class CheckoutViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {

    @IBOutlet weak var deliveryMethodTableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var productDiscountLabel: UILabel!
    @IBOutlet weak var voucherDiscountLabel: UILabel!
    @IBOutlet weak var voucherText: UITextField!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var customerDiscountLabel: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var addressText: UITextView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityDropdownView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var voucherCodeText: UITextField!
    @IBOutlet weak var customerDiscountAmountLabel: UILabel!
    
    @IBOutlet weak var voucherDescription: UILabel!
    @IBOutlet weak var voucherRowHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var customerDiscountLabelHeightCons: NSLayoutConstraint!
    
    // second address
    @IBOutlet weak var firstNameSecond: UITextField!
    @IBOutlet weak var lastNameSecond: UITextField!
    @IBOutlet weak var phoneSecond: UITextField!
    @IBOutlet weak var addressSecond: UITextView!
    @IBOutlet weak var cityLabelSecond: UILabel!
    @IBOutlet weak var cityDropDownViewSecond: UIView!
    @IBOutlet weak var secondAdressViewContainerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var secondFormContainer: UIView!
    @IBOutlet weak var secondAdressSwitch: UISwitch!
    // second address end
    
    var activeField: UITextField? = nil
    var activeTextView: UITextView? = nil
    var dropDown = DropDown()
    var dropDown2 = DropDown()
    var dop: [String] = [ "Dhaka" ]
    var appliedVoucherCodes: [String] = []
    var appliedVouchers: [VoucherDiscount] = []
    var customerDiscount: Double = 0.0
    var customerDiscountDetails: CustomerPurchaseDiscount? = nil
    
    var selectedMethod = 0
    var deliveryMethods: [DeliveryMethod] = []
    var shippingDiscount: Double = 0.0
    
    var invoiceAddress = false
    
    var districts: [District] = []
    
    var totalPrice = Utility.shoppingCart.totalPrice
    var productDiscountTotal = Utility.shoppingCart.productDiscountTotal
    var shippingCost:Double = 0.0
    var voucherDiscountTotal: Double = 0.0
    var totalCost: Double = 0.0

    var inititalVoucherRowHeight: CGFloat = 0.0
    var initialtableHeight: CGFloat = 0.0
    var initialContainerHeight: CGFloat = 0.0
    
    var checkout: Checkout = Checkout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressText.delegate = self
        initialtableHeight = tableHeight.constant
        inititalVoucherRowHeight = voucherRowHeight.constant
        initialContainerHeight = containerHeight.constant
        self.addressText.delegate = self
        self.addressSecond.delegate = self
        self.deliveryMethodTableView.dataSource = self
        self.deliveryMethodTableView.delegate = self
        makeFieldsEmpty()
        fillUserInfo()
        loadCustomerDiscount()
        loadDeliveryMethod()
        loadDistricts()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.showDropDown))
        tapGesture.delegate = self
        self.cityDropdownView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.showDropDown2))
        tapGesture2.delegate = self
        self.cityDropDownViewSecond.addGestureRecognizer(tapGesture2)
        
        self.hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
    }
    
    func showDropDown() {
        dropDown.show()
    }
    
    func showDropDown2() {
        dropDown2.show()
    }
    
    func makeFieldsEmpty() {
        subTotalLabel.text = ""
        productDiscountLabel.text = ""
        shippingCostLabel.text = ""
        voucherDiscountLabel.text = ""
        totalCostLabel.text = ""
        self.dropDown.anchorView = cityDropdownView
        self.dropDown.dataSource = dop
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cityLabel.text = item
        }
        self.dropDown2.anchorView = cityDropDownViewSecond
        self.dropDown2.dataSource = dop
        self.dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cityLabelSecond.text = item
        }
    }
    
    func fillUserInfo(){
        if Utility.loggedIn {
            emailText.isEnabled = false
            emailText.text = Utility.user.email
            firstNameText.text = Utility.user.firstName
            lastNameText.text = Utility.user.lastName
            phoneText.text = Utility.user.phone
            addressText.text = Utility.user.details.address.address
            
            firstNameSecond.text = Utility.user.firstName
            lastNameSecond.text = Utility.user.lastName
            phoneSecond.text = Utility.user.phone
            addressSecond.text = Utility.user.details.address.address
            
            var city = Utility.user.details.shippingAddress.city
            if city == "" {
                city = "Dhaka"
            }
            cityLabel.text = city
            cityLabelSecond.text = city
        }
        else {
            emailText.text = ""
            firstNameText.text = ""
            lastNameText.text = ""
            phoneText.text = ""
            addressText.text = ""
            
            firstNameSecond.text = ""
            lastNameSecond.text = ""
            phoneSecond.text = ""
            addressSecond.text = ""
            
            cityLabel.text = "Dhaka"
            cityLabelSecond.text = "Dhaka"
        }
        if addressText.text.isEmpty {
            addressText.text = "Address"
            addressText.textColor = UIColor.lightGray
            addressSecond.text = "Address"
            addressSecond.textColor = UIColor.lightGray
        }
        else {
            addressText.textColor = UIColor.darkGray
            addressSecond.textColor = UIColor.darkGray
        }
        self.secondFormContainer.isHidden = true
        secondAdressViewContainerHeightCons.constant = 0.0
        containerHeight.constant = 1260
    }
    
    func initialize() {
        voucherCodeText.isEnabled = true
        Utility.shoppingCart.shippingCost = shippingCost
        Utility.shoppingCart.update()
        let cartItemCount = Utility.shoppingCart.mallBdPackageCell.count + Utility.shoppingCart.productCell.count
        var badge: String? = nil
        if cartItemCount > 0 {
            badge = String(cartItemCount)
        }
        self.tabBarController?.tabBar.items?[1].badgeValue = badge
        subTotalLabel.text = String(Utility.shoppingCart.totalPrice) + " " + Constants.bdtCurrency
        productDiscountLabel.text = String(Utility.shoppingCart.productDiscountTotal) + " " + Constants.bdtCurrency
        shippingCostLabel.text = String(shippingCost) + " " + Constants.bdtCurrency
        voucherDiscountLabel.text = String(voucherDiscountTotal) + " " + Constants.bdtCurrency
        totalCost = totalPrice - productDiscountTotal - voucherDiscountTotal - customerDiscount + shippingCost
        customerDiscountAmountLabel.text = "\(customerDiscount) \(Constants.bdtCurrency)"
        totalCostLabel.text = String(totalCost) + " " + Constants.bdtCurrency
    }
    
    func loadCustomerDiscount() {
        if Utility.loggedIn {
            ServiceProvider.getCustomerDiscount(false, view: self.view) { (discountResponse: CustomerDiscountResponse?) in
                if (discountResponse?.responseStat.status)! {
                    self.customerDiscountDetails = discountResponse?.responseData[0]
                    self.customerDiscountLabel.text = discountResponse?.discountMessage
                    let type = (self.customerDiscountDetails?.discount_type)!
                    if type == "Fixed" {
                        self.customerDiscount = (self.customerDiscountDetails?.discount_amount)!
                    }
                    else if type == "Percent" {
                        self.customerDiscount = ((self.customerDiscountDetails?.discount_amount)! / 100) * (self.totalPrice)
                    }
                }
                else {
                    self.customerDiscountLabel.text = ""
                }
                self.initialize()
            }
        }
    }
    
    func calculateShippingCost(){
        let method = deliveryMethods[selectedMethod]
        let limit = Double(method.delivery_price_limit)
        let shippingCharge = Double(method.deliveryPrice)
        if totalPrice <= limit {
            shippingCost = shippingCharge
        }
        else {
            shippingCost = 0.0
        }
        initialize()
    }
    
    func loadDeliveryMethod() {
        ServiceProvider.getDeliveryMethods(true, view: self.view) { (deliveryMethods: [DeliveryMethod]) in
            self.deliveryMethods += deliveryMethods
            self.deliveryMethodTableView.reloadData()
            self.calculateShippingCost()
        }
    }
    
    func loadDistricts() {
        ServiceProvider.getDistricts(true, view: self.view){ (districts: [District]) in
            self.districts += districts
            self.dop = []
            for district in districts {
                self.dop.append(district.name)
            }
            self.dropDown.dataSource = self.dop
            self.dropDown2.dataSource = self.dop
        }
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.secondFormContainer.isHidden =  false
            invoiceAddress = true
            secondAdressViewContainerHeightCons.constant = 340.0
            containerHeight.constant = 1600
        }
        else {
            self.secondFormContainer.isHidden = true
            invoiceAddress = false
            secondAdressViewContainerHeightCons.constant = 0.0
            containerHeight.constant = 1260
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func confrim(_ sender: AnyObject) {
        self.view.endEditing(true)
        gotoPayment()
    }
    
    func gotoPayment() {
        
        var isValid = true
        let fName = firstNameText.text!
        let lName = lastNameText.text!
        let email = emailText.text!
        let phone = phoneText.text!
        var address = ""
        print(addressText.textColor!)
        print(UIColor.darkGray)
        if addressText.textColor!.isEqual(UIColor.darkGray) {
            address = addressText.text
        }
        if email.characters.count == 0 {
            isValid = false
            Utility.showValidationError("Error", message: "Email is required", viewController: self)
        }
        else if (!Utility.isEmailValid(email)){
            isValid = false
            Utility.showValidationError("Error", message: "Email is not valid.", viewController: self)
        }
        else if fName.characters.count == 0 {
            isValid = false
            Utility.showValidationError("Error", message: "First name is required", viewController: self)
        }
        else if lName.characters.count == 0 {
            isValid = false
            Utility.showValidationError("Error", message: "Last name is required", viewController: self)
        }
        else if phone.characters.count != 11 {
            isValid = false
            Utility.showValidationError("Error", message: "Phone number must be of 11 digits", viewController: self)
        }
        else if address.characters.count == 0 {
            isValid = false
            Utility.showValidationError("Error", message: "Address is required", viewController: self)
        }
        let fName2 = firstNameSecond.text!
        let lName2 = lastNameSecond.text!
        let phone2 = phoneSecond.text!
        var address2 = ""
        if secondAdressSwitch.isOn {
            
            if addressSecond.textColor!.isEqual(UIColor.darkGray) {
                address2 = addressText.text!
            }
            if fName2.characters.count == 0 {
                isValid = false
                Utility.showValidationError("Error", message: "Invoice or Gift - First name is required", viewController: self)
            }
            else if lName2.characters.count == 0 {
                isValid = false
                Utility.showValidationError("Error", message: "Invoice or Gift - Last name is required", viewController: self)
            }
            else if phone2.characters.count != 11 {
                isValid = false
                Utility.showValidationError("Error", message: "Invoice or Gift - Phone number must be of 11 digits", viewController: self)
            }
            else if address2.characters.count == 0 {
                isValid = false
                Utility.showValidationError("Error", message: "Invoice or Gift - Address is required", viewController: self)
            }
        }
        if isValid {
            let city = cityLabel.text!
            let orderFrom = "IOS"
            let shippingAdress = address2
            let shippingCity = cityLabelSecond.text!
            let deliveryMethodId = deliveryMethods[selectedMethod].id
            let paymentMethodId = 0
            let currencyId = 1
            let shoppingCart = Utility.shoppingCart
            
            self.checkout.first_name = fName
            self.checkout.last_name = lName
            self.checkout.email = email
            self.checkout.phone = phone
            self.checkout.address = address
            self.checkout.city = city
            
            self.checkout.order_from = orderFrom
            
            self.checkout.invoice_address = self.invoiceAddress
            self.checkout.shipping_firstname = fName2
            self.checkout.shipping_lastname = lName2
            self.checkout.shipping_phone = phone2
            self.checkout.shipping_address = addressSecond.text!
            self.checkout.shipping_city = shippingCity
            
            self.checkout.delivery_method_id = deliveryMethodId
            self.checkout.payment_method_id = paymentMethodId
            self.checkout.currency_id = currencyId
            
            self.checkout.customerDiscountDetails = self.customerDiscountDetails
            self.checkout.voucherDiscountDetails = self.appliedVouchers
            self.checkout.customerDiscount = self.customerDiscount
            
            self.checkout.shopping_cart = shoppingCart
            
            performSegue(withIdentifier: "GotoPayment", sender: self.checkout)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoPayment" {
            let checkout = sender as! Checkout
            let destinationVC = segue.destination as! PaymentViewController
            destinationVC.checkout = checkout
        }
    }
    
    func voucherCodeUsed(_ code : String) -> Bool {
        for voucher in appliedVouchers {
            if (code == voucher.voucherCode!) {
                return true
            }
        }
        return false
    }
    
    @IBAction func applyVoucherCode(_ sender: UIButton) {
        let voucherCode = voucherCodeText.text
        if voucherCode?.characters.count == 0 {
            self.view.makeToast(message: "Invalid Voucher code")
        }
        else if voucherCodeUsed(voucherCode!) {
            self.view.makeToast(message: "Code already used")
        }
        else {
            ServiceProvider.applyVoucherCode(voucherCode!, showLoader: true, view: self.view){ (voucherDiscount: VoucherDiscount) in
                print(voucherDiscount.discount)
                let previusText = self.voucherDescription.text!
                let vDiscountAmount = ((voucherDiscount.discount / 100) * self.totalPrice)
                self.voucherDiscountTotal += vDiscountAmount
                self.voucherDescription.text = "\(previusText) \nCode: \(voucherDiscount.voucherCode!) : Discount: \(vDiscountAmount) \(Constants.bdtCurrency)"
                let labelHeight = self.voucherDescription.frame.height
                self.tableHeight.constant = self.initialtableHeight + labelHeight
                self.voucherRowHeight.constant = self.inititalVoucherRowHeight + labelHeight
                Utility.shoppingCart.voucherDiscount = self.voucherDiscountTotal
                Utility.shoppingCart.update()
                let cartItemCount = Utility.shoppingCart.mallBdPackageCell.count + Utility.shoppingCart.productCell.count
                var badge: String? = nil
                if cartItemCount > 0 {
                    badge = String(cartItemCount)
                }
                self.tabBarController?.tabBar.items?[1].badgeValue = badge
                self.containerHeight.constant = self.initialContainerHeight + labelHeight
                self.view.layoutIfNeeded()
                self.initialize()
                self.appliedVouchers.append(voucherDiscount)
                self.voucherCodeText.text = ""
            }
        }
    }
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(CheckoutViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CheckoutViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if activeField != nil {
            if (!aRect.contains(activeField!.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        else if activeTextView != nil {
            if (!aRect.contains(activeTextView!.frame.origin)){
                self.scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        //        let info : NSDictionary = notification.userInfo!
        //        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        //        self.scrollView.scrollEnabled = false
    }
    
    private func textFieldDidBeginEditing(_ textField: UITextField!) {
        activeField = textField
    }
    
    private func textFieldDidEndEditing(_ textField: UITextField!) {
        activeField = nil
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //        print("i am in edit mode")
        activeTextView = textView
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
        if textView.text.isEmpty {
            textView.text = "Address"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

extension CheckoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deliveryMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryMethodTableViewCell") as! DeliveryMethodTableViewCell
        let deliveryMethod = self.deliveryMethods[(indexPath as NSIndexPath).row]
        cell.deliveryCost.text = "\(deliveryMethod.deliveryPrice) \(Constants.bdtCurrency)"
        cell.deliveryMethodDesc.text = deliveryMethod.title
        if (indexPath as NSIndexPath).row == selectedMethod {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryView = .none
        }
        cell.tintColor = UIColor(netHex: 0xAE1522)
        return cell
    }
    
}

extension CheckoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMethod = (indexPath as NSIndexPath).row
        for index in 0...self.deliveryMethods.count - 1 {
            if let cell = deliveryMethodTableView.cellForRow(at: IndexPath(row: index, section: 0)) {
                cell.accessoryType = .none
            }
        }
        if let cell = deliveryMethodTableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        self.calculateShippingCost()
    }
    
    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Choose your delivery method"
    }
    
}
