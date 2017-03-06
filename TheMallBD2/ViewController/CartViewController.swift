import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cartTable: UITableView!
    var tableInEditMode = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTable()
    }
    
    func loadTable(){
        cartTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return Utility.shoppingCart.productCell.count
        }
        else {
            return Utility.shoppingCart.mallBdPackageCell.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = cartTable.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            cell.cellType = "product"
            cell.index = indexPath.row
            let productCell = Utility.shoppingCart.productCell[(indexPath as NSIndexPath).row]
            let product = productCell.product
            cell.title.text = product?.title
            let price = product?.prices[0].retailPrice
            if (product?.discountActiveFlag)! {
                let currentPrice = price! - (product?.discountAmount)!
                let subTotal = currentPrice * Double(productCell.quantity)
                cell.price.text = String(currentPrice) + " " + Constants.bdtCurrency
                cell.subTotal.text = String(subTotal) + " " + Constants.bdtCurrency
            }
            else {
                let subTotal = price! * Double(productCell.quantity)
                cell.price.text = String(describing: price!) + " " + Constants.bdtCurrency
                cell.subTotal.text = String(subTotal) + " " + Constants.bdtCurrency
            }
            cell.quantity.text = String(productCell.quantity)
            var pictures: [Picture] = product!.pictures
            if pictures.count > 0 {
                cell.picture.kf.setImage(with: URL(string: Constants.backOffice+"product/general/"+pictures[0].name)!)
            }
            cell.cartProductCell = productCell
            cell.vc = self
            return cell
        }
        else {
            let cell = cartTable.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            cell.cellType = "package"
            cell.index = indexPath.row
            cell.vc = self
            let packageCell = Utility.shoppingCart.mallBdPackageCell[(indexPath as NSIndexPath).row]
            let package = packageCell.mallBdPackage
            cell.title.text = package?.packageTitle
            let price: Float = (package?.packagePriceTotal)!
            let subTotal = Double(price) * Double(packageCell.quantity)
            cell.price.text = String(price) + " " + Constants.bdtCurrency
            cell.subTotal.text = String(subTotal) + " " + Constants.bdtCurrency
            cell.quantity.text = String(packageCell.quantity)
            cell.picture.kf.setImage(with: URL(string: Constants.backOffice + "package/general/" + (package?.image)!)!)
            cell.cartPackageCell = packageCell
            cell.vc = self
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartTable.dataSource = self
        self.cartTable.tableFooterView = UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if (indexPath as NSIndexPath).section == 0 {
                Utility.shoppingCart.productCell.remove(at: (indexPath as NSIndexPath).row)
            }
            else {
                Utility.shoppingCart.mallBdPackageCell.remove(at: (indexPath as NSIndexPath).row)
            }
            Utility.shoppingCart.update()
            let cartItemCount = Utility.shoppingCart.mallBdPackageCell.count + Utility.shoppingCart.productCell.count
            var badge: String? = nil
            if cartItemCount > 0 {
                badge = String(cartItemCount)
            }
            self.tabBarController?.tabBar.items?[1].badgeValue = badge
            loadTable()
//            print("\((indexPath as NSIndexPath).row) deleted")
        }
    }
    
    @IBAction func editMode(_ sender: UIBarButtonItem) {
        if tableInEditMode {
            cartTable.setEditing(false, animated: true)
            tableInEditMode = false
            sender.title = "Edit"
        }
        else {
            cartTable.setEditing(true, animated: true)
            tableInEditMode = true
            sender.title = "Done"
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.cartTable.setEditing(editing, animated: animated)
    }
    
    @IBAction func goToCheckout(_ sender: UIBarButtonItem) {
        if Utility.shoppingCart.mallBdPackageCell.count == 0 && Utility.shoppingCart.productCell.count == 0 {
            self.view.makeToast(message: "Your Cart is empty")
        }
        else {
            performSegue(withIdentifier: "Checkout", sender: sender)
        }
    }
    
    
}
