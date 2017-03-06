import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var formContainer: UIView!
    var tabBarC: UITabBarController? = nil
    var toIndex = 3
    var itemToShow = 0
    var activeViewController: UIViewController? = nil
    
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segment.layer.cornerRadius = 0.0
        self.segment.layer.borderColor = UIColor(netHex: 0xAE1522).cgColor
        self.segment.layer.borderWidth = 1.0
        self.segment.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if itemToShow == 0 {
            showLoginForm()
        }
        else {
            showRegistrationForm()
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showLoginForm()
        case 1:
            showRegistrationForm()
        default:
            break; 
        }
    }
    
    func showLoginForm(){
        emptyContainer()
        let loginVC: LoginController2 = storyboard?.instantiateViewController(withIdentifier: "LoginController2") as! LoginController2
        loginVC.tabBarC = self.tabBarC
        loginVC.toIndex = self.toIndex
        self.addChildViewController(loginVC)
        loginVC.view.frame = self.formContainer.bounds
        self.formContainer.addSubview(loginVC.view)
        activeViewController = loginVC
        loginVC.didMove(toParentViewController: self)
    }
    
    func showRegistrationForm(){
        emptyContainer()
        let regVC: RegViewController = storyboard?.instantiateViewController(withIdentifier: "RegViewController") as! RegViewController
        self.addChildViewController(regVC)
        regVC.view.frame = self.formContainer.bounds
        self.formContainer.addSubview(regVC.view)
        activeViewController = regVC
        regVC.didMove(toParentViewController: self)
    }
   
    func emptyContainer(){
        print("called")
        activeViewController?.willMove(toParentViewController: nil)
        activeViewController?.view.removeFromSuperview()
        activeViewController?.removeFromParentViewController()
    }
    
    @IBAction func closeModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
