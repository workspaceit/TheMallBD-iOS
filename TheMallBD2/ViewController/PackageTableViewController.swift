import UIKit

class PackageTableViewController: UITableViewController {

    var packages: [Package] = []
    var index = 0
    var limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load() {
        var showLoader = false
        if self.index == 0 {
            showLoader = true
        }
        ServiceProvider.getPackagesByLimit(index, limit: self.limit, showLoader: showLoader, view: self.view){ (packages: [Package]) in
            self.packages += packages
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.packages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageTableCell", for: indexPath) as! PackageTableViewCell
        let package = packages[(indexPath as NSIndexPath).row]
        cell.title.text = package.packageTitle
        cell.price.text = String(package.packagePriceTotal)
        cell.productImage.kf.setImage(with: URL(string: Constants.backOffice + "package/general/" + package.image)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToPackage", sender: indexPath)
    }
 
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPackage" {
            let indexPath = sender as! IndexPath
            let destinationVC = segue.destination as! PackageViewController
            destinationVC.package = packages[(indexPath as NSIndexPath).row]
        }
    }
 

}
