import UIKit
import KVNProgress

class ProductTableViewController: UITableViewController {
    
    var products: [Product] = []
    var product: Product!
    var index: Int = 0
    var limit: Int = 10
    var type: String = ""
    var keyword: String = ""
    var category: Categories!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        load()
    }
    
    func load(){
        
        var showLoader = false
        if self.index == 0 {
            showLoader = true
        }
        
        switch (self.type) {
            
            case "new":
                print("newp")
                
                let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                pagingSpinner.startAnimating()
                pagingSpinner.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
                pagingSpinner.hidesWhenStopped = true
                tableView.tableFooterView = pagingSpinner
                
                
                ServiceProvider.getProductsByLimit(self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                    self.products += products
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
                break
            case "featured":
                print("featured")
                ServiceProvider.getFeaturedProductsByLimit(self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                    self.products += products
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
                break
            
            case "related":
                print("related")
                ServiceProvider.getRelatedProducts(product.id,product_category_id: product.categories[0].id, offset: self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                    self.products += products
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
                break
            case "category":
                print("related")
                ServiceProvider.getProductsByCategory(category.id, offset: self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                    self.products += products
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
                break
            case "search":
                print("search")
                ServiceProvider.searchProductByKeyword(self.keyword, offset: self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                    self.products += products
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
                break
            default:
                tableView.frame.size.height = 140
                break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell", for: indexPath) as! ProductTableViewCell
        let product: Product = products[(indexPath as NSIndexPath).row]
        cell.title.text = product.title
        var prices:[Prices] = product.prices
        var price = ""
        if prices.count > 0 {
            price = String(prices[0].retailPrice)
        }
        cell.price.text = price + " " + Constants.bdtCurrency
        var pictures: [Picture] = product.pictures
        if pictures.count > 0 {
//            cell.productImage.kf_showIndicatorWhenLoading = true
            cell.productImage.kf.setImage(with: URL(string: Constants.backOffice+"product/general/"+pictures[0].name)!)
        }
        cell.manufacturer.text = product.manufacturer.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
 
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (((indexPath as NSIndexPath).row == self.products.count - 1) && (self.type != "related_three")) {
            self.index += 1
            self.load()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProductDetailPage", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetailPage" {
            let product = self.products[((sender as! NSIndexPath).row)]
            let destinationVC = segue.destination as! ProductViewController
            destinationVC.product = product
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.type == "search" {
            return "Saerch result for '\(self.keyword)'"
        }
        return ""
    }
    
}
