import UIKit

class ReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var reviewTable: UITableView!
    var product: Product!
    var reviews: [Review] = []
    var type = ""
    var index = 0
    var limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTable.dataSource = self
        reviewTable.delegate = self
        reviewTable.tableFooterView = UIView(frame: .zero)
        if self.type != "review_3" {
            self.load()
        }
    }
    
    func load(){
        var showLoader = false
        if self.type == "review_3" || self.index == 0 {
            showLoader = true
        }
        ServiceProvider.getReviewsByProduct(self.product.id, offset: self.index, limit: self.limit, showLoader: showLoader, view: self.view) { (reviews: [Review]) in
            self.reviews += reviews
            print("total review: \(self.reviews.count)")
            self.reviewTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        let review = reviews[(indexPath as NSIndexPath).row]
        cell.note.text = review.note
        cell.reviewer.text = "\(review.customer.firstName) \(review.customer.lastName)"
        cell.reviewDate.text = review.createdOn
        cell.ratingView.rating = Double(review.rating)!
        return cell
    }

}
