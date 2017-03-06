import UIKit

class TestController: UIViewController {
    
    
    var tabBarController1: TabBarController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController1?.selectedIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("i am appearing")
        tabBarController1?.selectedIndex = 0
    }
    
    @IBOutlet weak var clicked: UIButton!
    @IBAction func click(_ sender: UIButton) {
        print(self.tabBarController1!)
//        presentViewController(tabBarController1!, animated: true, completion: nil)
        _ = navigationController?.popToRootViewController(animated: true)
//        navigationController?.popViewControllerAnimated(true)
    }
}
