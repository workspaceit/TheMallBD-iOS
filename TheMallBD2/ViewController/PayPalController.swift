import UIKit

class PayPalController: UIViewController {
    
    @IBOutlet weak var amountBDT: UILabel!
    @IBOutlet weak var amountUSD: UILabel!
    
    var payment: Payment? = nil
    var resultText = ""
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    #if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    #else
    var acceptCreditCards: Bool = false {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = "The Mall BD"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal
        
        amountBDT.text = "Amount: \(Double((payment?.orderGrandTotal)!)) BDT"
        amountUSD.text = "Paypal Amount: \(Double((payment?.paypalPayAmount)!)) USD"
        
    }
    
    @IBOutlet weak var payWithPaypal: UIButton!
    
    @IBAction func payWithPaypal(_ sender: UIButton) {
        let item1 = PayPalItem(name: "Shopping", withQuantity: 1, withPrice: NSDecimalNumber(string: String(format:"%.1f", (self.payment?.paypalPayAmount)!)), withCurrency: "USD", withSku: "Hip-0037")
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "The Mall BD", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
    }
    
}


extension PayPalController: PayPalPaymentDelegate {
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        resultText = ""
//        successView.hidden = true
        ServiceProvider.cancelOrder((payment?.orderId)!, showLoader: false, view: self.view) {
            (response: AnyObject) in
        }
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
//            print("Here is your proof of payment:\n\n\(completedPayment.confirmation.description)\n\nSend this to your server for confirmation and fulfillment.")
            ServiceProvider.orderSuccess((self.payment?.orderId)!, payment_details: completedPayment.confirmation.description, showLoader: true, view: self.view) {
                (response: AnyObject) in
                print(response)
            }
        })
    }
    
}
