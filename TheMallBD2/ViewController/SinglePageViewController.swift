import UIKit

class SinglePageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageFileName: String!
    var pageIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named:imageFileName)
    }

}
