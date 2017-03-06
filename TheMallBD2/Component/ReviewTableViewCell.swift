import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var reviewer: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
