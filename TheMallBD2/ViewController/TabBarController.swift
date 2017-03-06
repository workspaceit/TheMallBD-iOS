import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print("tab selected")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title != nil {
            if viewController.title! == "MyMallBD" {
                if !Utility.loggedIn {
                    showMessage("Login", message: "You need to login first to use this feature.", type: "login")
                    return false
                }
            }
        }
        return true
    }
    
    func showMessage(_ title: String, message: String, type: String){
        if type == "login" {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//            alertController.view.tintColor = UIColor(netHex: 0xAE1522)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction!) in
            })
            alertController.addAction(cancelAction)
            let loginAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
                vc.tabBarC = self
                self.present(vc, animated: true, completion: nil)
            })
            alertController.addAction(loginAction)
            present(alertController, animated: true, completion: nil)
        }
    }

}
