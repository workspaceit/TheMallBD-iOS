import UIKit

class OrderTableViewController: UITableViewController {

    var oders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Your order history"
        load()
    }
    
    func load() {
        ServiceProvider.getOrders(true, view: self.view) { (orders: [Order]) in
            self.oders += orders
            self.tableView.reloadData()
            print(orders.count)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.oders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = self.oders[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        let serialNo = (indexPath as NSIndexPath).row + 1
        cell.searialNo.text = String(serialNo)
        cell.orderDate.text = order.createdOn
        let total: Double = order.orderTotal
        cell.orderTotal.text = String(total)
        cell.invoiceNo.text = order.invoiceNo
        cell.fff.text = order.shippingAddress
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OrderDetails", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetails" {
            let indexPath = sender as! IndexPath
            let dVc = segue.destination as! OrderViewController
            dVc.order = self.oders[(indexPath as NSIndexPath).row]
        }
    }

}
