import UIKit
import KVNProgress

class PaymentViewController: UIViewController {

    @IBOutlet weak var paymentMethodTable: UITableView!
    
    var paymentMethods: [PaymentMethod] = []
    var selectedMethod = 0
    var checkout: Checkout? = nil
    var payment: Payment? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentMethodTable.dataSource = self
        paymentMethodTable.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        ServiceProvider.getPaymentMethods(true, view: self.view) { (paymentMethods: [PaymentMethod]) in
            self.paymentMethods += paymentMethods
            self.paymentMethodTable.reloadData()
        }
    }
    
    @IBAction func proceed(_ sender: UIBarButtonItem) {
        proceed()
    }
    
    func proceed() {
        self.checkout?.payment_method_id = self.paymentMethods[self.selectedMethod].id
        self.checkout?.city = "Dhaka"
        
        ServiceProvider.order(self.checkout!,vc: self, showLoader: true, view: self.view) { (payment: Payment) in
            self.payment = payment
            
            if self.selectedMethod == 0 {
                Utility.clearCart()
                _ = self.navigationController?.popToRootViewController(animated: false)
                self.showMessage("Cash", message: "Your order is placed successfully", type: "cash")
                
            }
            else if self.selectedMethod == 1 {
                self.showMessage("BKash", message: "Go to Bkash Payment page", type: "bkash")
            }
            else if self.selectedMethod == 2 {
                self.showMessage("Paypal", message: "Go to PayPal Payment page", type: "paypal")
            }
            else if self.selectedMethod == 3 {
                self.showMessage("Payment Gateway", message: "Go to Payment Gateway", type: "walletmix")
            }
        }
    }
    
    func showMessage(_ title: String, message: String, type: String){
        if type == "bkash" {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.view.tintColor = UIColor(netHex: 0xAE1522)
            let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.performSegue(withIdentifier: "BkashPayment", sender: self.payment)
            })
            alertController.addAction(continueAction)
            present(alertController, animated: true, completion: nil)
        }
        else if type == "paypal" {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.view.tintColor = UIColor(netHex: 0xAE1522)
            let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.performSegue(withIdentifier: "PaypalPayment", sender: self.payment)
            })
            alertController.addAction(continueAction)
            present(alertController, animated: true, completion: nil)
        }
        else if type == "walletmix" {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.view.tintColor = UIColor(netHex: 0xAE1522)
            let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                self.performSegue(withIdentifier: "WalletMix", sender: self.payment)
            })
            alertController.addAction(continueAction)
            present(alertController, animated: true, completion: nil)
        }
        else if type == "cash" {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.view.tintColor = UIColor(netHex: 0xAE1522)
            let continueAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                
            })
            alertController.addAction(continueAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BkashPayment" {
            let dVc = segue.destination as! BkashPaymentViewController
            dVc.payemnt = self.payment
        }
        else if segue.identifier == "PaypalPayment" {
            let dVc = segue.destination as! PayPalController
            dVc.payment = self.payment
        }
        else if segue.identifier == "WalletMix" {
            let dVc = segue.destination as! WalletMixController
            dVc.payment = self.payment
        }
    }

}

extension PaymentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let method: PaymentMethod = self.paymentMethods[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = method.methodTitle
        cell.tag = method.id
        if (indexPath as NSIndexPath).row == selectedMethod {
            cell.accessoryType = .checkmark
        }
        cell.textLabel!.font = UIFont(name: "whitney-book", size: 17.0)
        return cell
    }
    
}

extension PaymentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMethod = (indexPath as NSIndexPath).row
        for index in 0...paymentMethods.count - 1 {
            if let cell = paymentMethodTable.cellForRow(at: IndexPath(row: index, section: 0)) {
                cell.accessoryType = .none
            }
        }
        if let cell = paymentMethodTable.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Choose your delivery method"
//    }
    
}
