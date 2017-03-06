import UIKit
import Kingfisher

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var categoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTable.dataSource = self
        categoryTable.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utility.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = Utility.categories[(indexPath as NSIndexPath).row]
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.catName.text = category.title
        cell.catImage.kf.setImage(with: URL(string: Constants.backOffice+"category/banner/" + category.banner)!)
        cell.blurViewWidthConstraint.constant = (cell.catName?.intrinsicContentSize.width)! + 4
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
        performSegue(withIdentifier: "ExpandableCategories", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath: IndexPath = sender as! IndexPath
        if segue.identifier == "ExpandableCategories" {
            let destinationVC = segue.destination as! ExpandableCategoriesViewController
            destinationVC.preSelectedCategory = Utility.categories[(indexPath as NSIndexPath).row]
            destinationVC.fromCategoryPage = true
        }
    }
    
}

