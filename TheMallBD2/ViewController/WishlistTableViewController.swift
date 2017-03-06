import UIKit

class WishlistTableViewController: UITableViewController {

    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        self.load()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func load() {
        ServiceProvider.getWishList(true, view: self.view) { (products: [Product]) in
            self.products += products
            self.tableView.reloadData()
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = self.products[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistTableViewCell", for: indexPath) as! WishlistTableViewCell
        cell.productTitle.text = product.title
        var prices:[Prices] = product.prices
        var price = ""
        if prices.count > 0 {
            price = String(prices[0].retailPrice)
        }
        cell.productPrice.text = price + " " + Constants.bdtCurrency
        var pictures: [Picture] = product.pictures
        if pictures.count > 0 {
            cell.productImage.kf.setImage(with: URL(string: Constants.backOffice+"product/general/"+pictures[0].name)!)
        }
        
        cell.addToCartButton.tag = (indexPath as NSIndexPath).row
        cell.addToCartButton.addTarget(self, action: #selector(WishlistTableViewController.addToCart), for: UIControlEvents.touchUpInside)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func addToCart(_ sender: UIButton){
        print(sender.tag)
        let product = products[sender.tag]
        var message: String = ""
        let q: Int = 1
        var alreadyExists = false
        let productsInCart: [CartProductCell] = Utility.shoppingCart.productCell
        for proCell: CartProductCell in productsInCart {
            if proCell.product.id == product.id {
                alreadyExists = true
                proCell.quantity = q
                message = "Product already exixts. Quantity updated."
                break
            }
        }
        if !alreadyExists {
            let productCell: CartProductCell = CartProductCell(id: product.id, product: product, quantity: q)
            Utility.shoppingCart.productCell.append(productCell)
            message = "Product Added to Cart"
        }
        Utility.shoppingCart.update()
        let cartItemCount = Utility.shoppingCart.mallBdPackageCell.count + Utility.shoppingCart.productCell.count
        var badge: String? = nil
        if cartItemCount > 0 {
            badge = String(cartItemCount)
        }
        self.tabBarController?.tabBar.items?[1].badgeValue = badge
        showMessage("Added", message: message)
    }
    
    func showMessage(_ title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = UIColor(netHex: 0xAE1522)
        let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            print("Continue button tapped")
        })
        alertController.addAction(continueAction)
        let okAction = UIAlertAction(title: "Checkout", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            print("Should go to Basket")
            self.tabBarController?.selectedIndex = 1
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowProductFromWishlist", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductFromWishlist" {
            let product = self.products[(sender as! NSIndexPath).row]
            let productVC = segue.destination as! ProductViewController
            productVC.product = product
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ServiceProvider.removeProductFromWishlist(self.products[indexPath.row].id, vc: self, showLoader: true, view: self.view) { (success: Bool) in
                if success {
                    self.view.makeToast(message: "Product removed from wishlist");
                    self.products.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
                }
            }
        }
    }

}
