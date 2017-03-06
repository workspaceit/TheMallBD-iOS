import UIKit

class PackageProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productManufacturer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
