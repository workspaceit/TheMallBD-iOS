import UIKit

class ButtonCell: UICollectionViewCell {
    
    @IBOutlet weak var cat1: UIView!
    @IBOutlet weak var cat2: UIView!
    @IBOutlet weak var cat3: UIView!
    @IBOutlet weak var cat4: UIView!
    
    @IBOutlet weak var cat1Image: UIImageView!
    @IBOutlet weak var cat1Title: UILabel!
    
    @IBOutlet weak var cat2Image: UIImageView!
    @IBOutlet weak var cat2Title: UILabel!
    
    @IBOutlet weak var cat3Image: UIImageView!
    @IBOutlet weak var cat3Title: UILabel!
    
    @IBOutlet weak var cat4Image: UIImageView!
    @IBOutlet weak var cat4Title: UILabel!
    
    var viewController: HCollectionViewController! = nil
    
    override func awakeFromNib() {
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ButtonCell.tapAction))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(ButtonCell.tapAction))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(ButtonCell.tapAction))
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(ButtonCell.tapAction))
        
        self.cat4.addGestureRecognizer(tapGesture4)
        self.cat1.addGestureRecognizer(tapGesture1)
        self.cat2.addGestureRecognizer(tapGesture2)
        self.cat3.addGestureRecognizer(tapGesture3)
        
    }
    
    func tapAction(_ sender: UITapGestureRecognizer) {
        let tag =  sender.view!.tag
        if tag == 0 {
            self.viewController.performSegue(withIdentifier: "Categories", sender: "")
        }
        else {
            self.viewController.performSegue(withIdentifier: "ExCat", sender: tag)
        }
    }
    
}
