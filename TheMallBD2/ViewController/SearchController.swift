import UIKit
import Kingfisher

class SearchController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    let searchController = UISearchController(searchResultsController: nil)
    var filteredProducts: [ProductSuggestion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = filteredProducts[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableCell", for: indexPath) as! SearchResultTableCell
        cell.productTitle.text = product.product_title
        cell.productImage.kf.setImage(with: URL(string: Constants.backOffice+"product/general/"+product.image_name)!)
        return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        print(searchText)
        if searchText.characters.count > 2 {
            searchByKeyword(searchText)
        }
        else {
            self.filteredProducts = []
            self.tableView.reloadData()
        }
    }
    
    func searchByKeyword(_ keyword: String) {
        ServiceProvider.searchProductSuggestionByKeyword(keyword, limit: 50, showLoader: false, view: self.view) { (products: [ProductSuggestion]) in
            self.filteredProducts = products
            self.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "ShowSearchResult", sender: searchBar.text)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productId = filteredProducts[(indexPath as NSIndexPath).row].id
        performSegue(withIdentifier: "GoToProduct", sender: productId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToProduct" {
            let destinationVC = segue.destination as! ProductViewController
            destinationVC.type = "toBeLoaded"
            destinationVC.productId = sender as! Int
        }
        else if segue.identifier == "ShowSearchResult" {
            let destinationVC = segue.destination as! ItemCollectionViewController
            destinationVC.type = "search"
            destinationVC.keyword = sender as! String
        }      
    }

}
