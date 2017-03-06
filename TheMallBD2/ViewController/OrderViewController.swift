import UIKit

class OrderViewController: UIViewController {
    
    var order: Order!

    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var shipment: UILabel!
    @IBOutlet weak var voucher: UILabel!
    @IBOutlet weak var productDisc: UILabel!
    @IBOutlet weak var special: UILabel!
    @IBOutlet weak var emplyee: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var itemTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTable.dataSource = self
        subTotal.text = "Subtotal: \(order.orderTotal)  \(Constants.bdtCurrency)"
        shipment.text = "Shipment Fee: \(order.shipping_cost) \(Constants.bdtCurrency)"
        voucher.text = "Voucher Discount: \(order.voucher_discount) \(Constants.bdtCurrency)"
        productDisc.text = "Product Discount: \(order.discount_totalP) \(Constants.bdtCurrency)"
        special.text = "Special Discount: \(order.special_discount) \(Constants.bdtCurrency)"
        emplyee.text = "Employee Discount: \(order.employee_discount) \(Constants.bdtCurrency)"
        total.text = "Total: \(order.orderTotal) \(Constants.bdtCurrency)"
    }
    
}

extension OrderViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.orderProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderProduct = order.orderProducts[(indexPath as NSIndexPath).row]
        let cell = itemTable.dequeueReusableCell(withIdentifier: "OrderItemCell") as! OrderItemCell
        cell.price.text = String(orderProduct.price)
        cell.quantity.text = String(orderProduct.productQuantity)
        cell.type.text = orderProduct.itemType
        let subTotal = orderProduct.price * Double(orderProduct.productQuantity)
        cell.subTotal.text = String(subTotal)
        cell.itemTitle.text = ""
        if orderProduct.itemType ==  "product" {
            cell.itemTitle.text = orderProduct.productitem?.title
        }
        else {
            cell.itemTitle.text = orderProduct.packageitem?.packageTitle
        }
        return cell
    }
    
}
