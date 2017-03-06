import UIKit

class BkashPaymentViewController: UIViewController {

    var payemnt: Payment!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bkashChargeLable: UILabel!
    
    @IBOutlet weak var senderMobile: UITextField!
    @IBOutlet weak var trxId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        load()
    }
    
    func load() {
        amountLabel.text = "Amount: \(payemnt.orderGrandTotal) BDT"
        bkashChargeLable.text = "BKash Charge: \(payemnt.bkashCharge) BDT"
        totalLabel.text = "Total: \(payemnt.totalBkashPay) BDT"
    }
    
    @IBAction func backToCart(_ sender: UIButton) {
        
    }
    
    @IBAction func payNow(_ sender: UIButton) {
        var valid = true
        let senderNumber = self.senderMobile.text
        let trx = self.trxId.text
        if senderNumber?.characters.count != 11 {
            valid = false
            Utility.showValidationError("Error", message: "Mobile number must be of 11 digits", viewController: self)
        }
        else if trx?.characters.count != 10 {
            valid = false
            Utility.showValidationError("Error", message: "bKash TRXID invalid", viewController: self)
        }
        if valid {
            ServiceProvider.BkashPayment(self.payemnt.uniqueCode, mobileNumber: senderNumber!, transactionId: trx!, showLoader: true, vc: self, view: self.view) {
                (bkashResponse: AnyObject?) in
                Utility.clearCart()
            }
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        print("hello")
    }
    
}
