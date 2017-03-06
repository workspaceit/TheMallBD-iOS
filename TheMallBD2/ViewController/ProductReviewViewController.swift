import UIKit
import Cosmos

class ProductReviewViewController: UIViewController {
    
    var product: Product!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var reviewText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.rating = 0
        ratingView.settings.minTouchRating = 0
        ratingView.settings.fillMode = .half
        ratingValueLabel.text = "0.0"
        ratingView.didTouchCosmos = { rating in
            self.ratingValueLabel.text = String(rating)
        }
        productTitleLabel.text = product.title
        
    }
    
    
    @IBAction func closeModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitReview(_ sender: UIButton) {
        let rating = ratingValueLabel.text
        let note = reviewText.text
        
        ServiceProvider.submitProductReview(self.product.id, note: note!, rating: rating!, user_id: 215, showLoader: true, vc: self, view: self.view) {
            (response: AnyObject?) in
            print(response!)
        }
    }
}
