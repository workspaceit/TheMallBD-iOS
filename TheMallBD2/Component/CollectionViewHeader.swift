import UIKit

class CollectionViewHeader: UICollectionReusableView {
    
    var type: String = ""
    var viewcontroller: UIViewController!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        print("clicked")
        if self.moreButton.tag == 6 {
            viewcontroller.performSegue(withIdentifier: "PackageList2", sender: self.moreButton)
        }
        else {
            viewcontroller.performSegue(withIdentifier: "ProductList2", sender: self.moreButton)
        }
    }
    
}
