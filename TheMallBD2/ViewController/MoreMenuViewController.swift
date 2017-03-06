import UIKit

class MoreMenuViewController: UIViewController {

    @IBOutlet weak var menuTable: UITableView!
    
    var menuItems:[Int: String] = [0: "Wishlist", 1: "Order History", 2: "App Feedback", 3: "About Us", 4: "Logout"]
    let menuImages:[Int: String] = [0: "nd_wishlist", 1: "nd_cart", 2: "feedback", 3: "nd_people", 4: "logout"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.menuTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.delegate = self
        self.menuTable.dataSource = self
        self.menuTable.delegate = self
        self.menuTable.tableFooterView = UIView(frame: .zero)
        self.menuTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

extension MoreMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Utility.loggedIn {
            return menuItems.count
        }
        return menuItems.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let image : UIImage = UIImage(named: menuImages[(indexPath as NSIndexPath).row]!)!
        cell.textLabel?.text = menuItems[(indexPath as NSIndexPath).row]
        cell.textLabel?.font = UIFont(name: "Whitney-Book", size: 18.0)
        cell.imageView!.image = image
        cell.imageView?.contentMode = UIViewContentMode.scaleToFill
        cell.imageView?.alpha = 0.6
        if (indexPath as NSIndexPath).row != 4 {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func showMessage(_ title: String, message: String, type: String){
        
        if type == "login" {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//            alertController.view.tintColor = UIColor(netHex: 0xAE1522)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert :UIAlertAction!) in
        
            })
            alertController.addAction(cancelAction)
            let loginAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                if !Utility.loggedIn {
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    vc.toIndex = 4
                    vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
//                    let pre = vc.presentationController
                    vc.tabBarC = self.tabBarController
                    self.present(vc, animated: true, completion: nil)
                }
            })
            alertController.addAction(loginAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension MoreMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            if Utility.loggedIn {
                performSegue(withIdentifier: "ShowWishlist", sender: 0)
            }
            else {
                showMessage("Login", message: "You need to login first", type: "login")
            }
        }
        else if (indexPath as NSIndexPath).row == 1 {
            if Utility.loggedIn {
                performSegue(withIdentifier: "ShowOrderHistory", sender: 0)
            }
            else {
                showMessage("Login", message: "You need to login first", type: "login")
            }
        }
        else if (indexPath as NSIndexPath).row == 2 {
            self.tabBarController?.selectedIndex = 0
        }
        else if (indexPath as NSIndexPath).row == 4 {
            ServiceProvider.logout(true, vc: self) {  (response: NSDictionary) in
                self.view.makeToast(message: "You are now logged out")
                Utility.clearUser()
                self.menuTable.reloadData()
            }
        }
    }
    
}


