import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var quantity: UILabel!
    var cartProductCell: CartProductCell!
    var cartPackageCell: CartPackageCell!
    var cellType = ""
    var index: Int?
    var vc: CartViewController?
    
    @IBAction func increaseQuantity(_ sender: UIButton) {
        var section = 0
        var maxQuantity = 0
        if self.cellType == "product" {
            maxQuantity = Int(self.cartProductCell.product.quantity)!
        }
        else {
            maxQuantity = 20
        }
        let currentQuantity = Int(quantity.text!)
        if ((currentQuantity! + 1) <= maxQuantity){
            quantity.text = String(Int(quantity.text!)! + 1)
        }
        
        if self.cellType == "product" {
            cartProductCell.quantity = Int(quantity.text!)!
        }
        else {
            section = 1
            cartPackageCell.quantity = Int(quantity.text!)!
        }
        updateCartAndReloadTable(row: self.index!, section: section)
    }

    @IBAction func decreaseQuantity(_ sender: UIButton) {
        let currentQuantity = Int(quantity.text!)
        var section = 0
        if self.cellType == "product" {
            let minimumOrderQuantity = cartProductCell.product.minimumOrderQuantity
            if((currentQuantity! - 1) >= minimumOrderQuantity) {
                quantity.text = String(Int(quantity.text!)! - 1)
                cartProductCell.quantity = Int(quantity.text!)!
            }
            else {
                let alertController = UIAlertController(title: "Remove Product", message: "Reducing the quantity less than minimum order quantity will remove the product from the Cart. Are you sure to remove?", preferredStyle: UIAlertControllerStyle.alert)
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                    Utility.shoppingCart.productCell.remove(at: self.index!)
                    Utility.shoppingCart.update()
                    self.vc?.loadTable()
                    self.updateBadge()
                })
                alertController.addAction(yesAction)
                let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                    
                })
                alertController.addAction(noAction)
                self.vc?.present(alertController, animated: true, completion: nil)
            }
            
        }
        else {
            section = 1
            if currentQuantity > 1 {
                quantity.text = String(Int(quantity.text!)! - 1)
                cartPackageCell.quantity = Int(quantity.text!)!
            }
            else{
                let alertController = UIAlertController(title: "Remove Product", message: "Reducing the quantity less than 1 will remove the package from the Cart. Are you sure to remove?", preferredStyle: UIAlertControllerStyle.alert)
                let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                    Utility.shoppingCart.mallBdPackageCell.remove(at: self.index!)
                    Utility.shoppingCart.update()
                    self.vc?.loadTable()
                    self.updateBadge()
                })
                alertController.addAction(yesAction)
                let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                    
                })
                alertController.addAction(noAction)
                self.vc?.present(alertController, animated: true, completion: nil)
            }
            
        }
        updateCartAndReloadTable(row: self.index!, section: section)
    }
    
    func updateCartAndReloadTable(row: Int, section: Int) {
        Utility.shoppingCart.update()
        var indexPathsToReload: [IndexPath] = []
        let indexPath = IndexPath(row: row, section: section)
        indexPathsToReload.append(indexPath)
        self.vc?.cartTable.reloadRows(at: indexPathsToReload, with: .none)
        updateBadge()
    }
    
    func updateBadge(){
        let cartItemCount = Utility.shoppingCart.mallBdPackageCell.count + Utility.shoppingCart.productCell.count
        var badge: String? = nil
        if cartItemCount > 0 {
            badge = String(cartItemCount)
        }
        vc?.tabBarController?.tabBar.items?[1].badgeValue = badge
    }
    
}
