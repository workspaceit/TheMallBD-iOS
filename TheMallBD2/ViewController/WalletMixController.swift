import UIKit

class WalletMixController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    var payment: Payment? = nil
    var url  = ""
    var callBack = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: false)
        load()
        
    }
    
    func load() {
        ServiceProvider.walletMixPayment((payment?.orderId)!, showLoader: true, vc: self, view: self.view) { (response: AnyObject?) in
            let data = response as! NSDictionary
            let url = data["wmx_url"] as! String
            self.url = url
            let callBackUrl = data["wmx_callback_url"] as! String
            self.callBack = callBackUrl
            UIWebView.loadRequest(self.webView)(URLRequest(url: URL(string: url)!))
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let currentUrl = webView.request!.url!.absoluteString
        print(currentUrl)
        if currentUrl == callBack {
//        if currentUrl != self.url {
//            self.navigationController?.popViewControllerAnimated(true)
            self.cancelOrder()
            _ = self.navigationController?.popToRootViewController(animated: false)
            dismiss(animated: true, completion: nil)
        }
        else if currentUrl == "http://sandbox.walletmix.com/abort" {
            self.cancelOrder()
//            _ = self.navigationController?.popToRootViewController(animated: false)
            self.view.makeToast(message: "Something went worng. Please try again")
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func closeWebView(_ sender: AnyObject) {
        showMessage("Cancel Order", message: "Do you want to cancel the order?", type: "cancel")
    }
    
    func showMessage(_ title: String, message: String, type: String){
        if type == "cancel" {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                self.cancelOrder()
                _ = self.navigationController?.popToRootViewController(animated: false)
            })
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                
            })
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func cancelOrder() {
        ServiceProvider.cancelOrder((self.payment?.orderId)!, showLoader: false, view: self.view){ (response: AnyObject) in
            
        }
    }
    
}
