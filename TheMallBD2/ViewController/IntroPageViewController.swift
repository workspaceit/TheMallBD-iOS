import UIKit

class IntroPageViewController: UIViewController , UIPageViewControllerDataSource{

    var pageImages: [String] = ["no_image", "no_image", "no_image"]
    var pageViewController:UIPageViewController!
    
    @IBOutlet weak var pageView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        if Utility.loggedIn {
//            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setShown()
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let initialContenViewController = self.pageTutorialAtIndex(0) as SinglePageViewController
        let viewControllers = NSArray(object: initialContenViewController)
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.pageView.frame.size.width, height: self.pageView.frame.size.height)
        self.addChildViewController(self.pageViewController)
        self.pageView.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }
    
    func setShown(){
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "walkthrough_shown")
    }
    
    func pageTutorialAtIndex(_ index: Int) -> SinglePageViewController{
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "SinglePageViewController") as! SinglePageViewController
        pageContentViewController.imageFileName = pageImages[index]
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        let viewController = viewController as! SinglePageViewController
        var index = viewController.pageIndex as Int
        if(index == 0 || index == NSNotFound){
            return nil
        }
        index -= 1
        return self.pageTutorialAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        let viewController = viewController as! SinglePageViewController
        var index = viewController.pageIndex as Int
        if((index == NSNotFound)){
            return nil
        }
        index += 1
        if(index == pageImages.count){
            return nil
        }
        return self.pageTutorialAtIndex(index)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int{
        return pageImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        return 0
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var singIn: UIButton!
    
    @IBAction func singIn(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.toIndex = 0
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        vc.tabBarC = self.tabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func singUp(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.itemToShow = 1
        vc.toIndex = 0
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        vc.tabBarC = self.tabBarController
        self.present(vc, animated: true, completion: nil)
    }

}
