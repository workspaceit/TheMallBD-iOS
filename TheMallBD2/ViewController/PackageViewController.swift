import UIKit
import DropDown
import ObjectMapper

class PackageViewController: UIViewController {
    
    var package: Package!
    
    @IBOutlet weak var packageTitle: UILabel!
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var rprValue: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var saveValue: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var rprLabel: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var productsContainer: UIView!
    @IBOutlet weak var packageDescription: UILabel!
    @IBOutlet weak var productsTable: UITableView!
    @IBOutlet weak var quantityDropdownView: UIView!
    @IBOutlet weak var productsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightContraint: NSLayoutConstraint!
    
    var dropDown = DropDown()
    var dop: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.productsTable.dataSource = self
        self.productsTable.delegate = self
        self.productsTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.dropDown.anchorView = quantityDropdownView
        self.dropDown.dataSource = dop
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.quantity.text = item
        }
    }
    
    func initialize(){
        self.packageTitle.text = package.packageTitle
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(package.originalPriceTotal) + " " + Constants.bdtCurrency)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))

        
        self.rprValue.attributedText = attributeString
        
        self.priceValue.text = String(package.packagePriceTotal)  + " " + Constants.bdtCurrency
        let saveAmount = (package.originalPriceTotal - package.packagePriceTotal)
        self.saveValue.text = String(saveAmount)  + " " + Constants.bdtCurrency
        self.packageDescription.text = package.packageDescription
        self.packageImage.kf.setImage(with: URL(string: Constants.backOffice+"package/general/"+package.image))
        productsTableHeightConstraint.constant = 150.0 * CGFloat(package.packageProducts.count)
        contentViewHeightContraint.constant += ((150.0 * CGFloat(package.packageProducts.count)) - 160)
        
        for q in 1 ..< 21 {
            dop.append(String(q))
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductViewController.showDropDown))
        self.quantityDropdownView.addGestureRecognizer(tapGesture)
        self.view.layoutIfNeeded()
    }
    
    func showDropDown(){
        dropDown.show()
    }

    @IBAction func addToBasket(_ sender: UIButton) {
        var message: String = ""
        let q: Int = Int(quantity.text!)!
        var alreadyExists = false
        let packagesInCart: [CartPackageCell] = Utility.shoppingCart.mallBdPackageCell
        for packageCell: CartPackageCell in packagesInCart {
            if packageCell.mallBdPackage.id == package.id {
                alreadyExists = true
                packageCell.quantity = q
                message = "Package already exixts. Quantity updated."
                break
            }
        }
        if !alreadyExists {
            let packCell: CartPackageCell = CartPackageCell(id: package.id, package: package, quantity: q)
            Utility.shoppingCart.mallBdPackageCell.append(packCell)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductFromPackage" {
            let product = self.package.packageProducts[(sender as! NSIndexPath).row].product
            let productVC = segue.destination as! ProductViewController
            productVC.product = product
        }
    }
    
}

extension PackageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return package.packageProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageProductTableViewCell") as! PackageProductTableViewCell
        let packageProduct = self.package.packageProducts[(indexPath as NSIndexPath).row]
        let product = packageProduct.product
        let quantity = packageProduct.quantity
        let price = packageProduct.price
        let pictures = product?.pictures
        
        cell.productTitle.text = product?.title
        cell.productPrice.text = String(price) + " " + Constants.bdtCurrency
        cell.productQuantity.text = String(quantity)
        cell.productManufacturer.text = packageProduct.product.manufacturer.name
        
        if (pictures?.count)! > 0 {
            cell.productImage.kf.setImage(with: URL(string: Constants.backOffice+"product/general/"+(pictures?[0].name)!))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowProductFromPackage", sender: indexPath)
    }
    
    
    
}
