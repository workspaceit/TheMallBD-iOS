import UIKit

class PackageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var packageCollection: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var packages: [Package] = []
    var index = 0
    var limit = 10
    var noMorePackages = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.packageCollection.dataSource = self
        self.packageCollection.delegate = self
        load()
        let width = packageCollection.frame.width
        let cellWidth = width * 0.6
        let cellHeight =  cellWidth + 50 + 10
        self.heightConstraint.constant = cellHeight
    }
    
    func load(){
        if !noMorePackages {
            ServiceProvider.getPackagesByLimit(index, limit: limit, showLoader: false, view: self.view) { (packages: [Package]) in
                if packages.count == 0 {
                    self.noMorePackages = true
                    self.view.makeToast(message: "No more Packages")
                }
                self.packages += packages
                self.packageCollection.reloadData()
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageCell",for:indexPath) as! PackageCell
        let package = packages[(indexPath as NSIndexPath).row]
        cell.price.text = String(package.packagePriceTotal) + " " + Constants.bdtCurrency
        cell.title.text = package.packageTitle
        cell.image.kf.setImage(with: URL(string: Constants.backOffice + "package/general/" + package.image))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == packages.count - 1 {
            self.index += 1
            self.load()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPackage", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width)
        let cellWidth = width * 0.6
        let cellHeight =  cellWidth + 50.0
        return CGSize(width: cellWidth , height: cellHeight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPackage" {
            let indexPath = sender as! IndexPath
            let package = packages[(indexPath as NSIndexPath).row]
            let destinationVC = segue.destination as! PackageViewController
            destinationVC.package = package
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"PackageCollectionViewFooter", for: indexPath)
        let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        pagingSpinner.startAnimating()
        pagingSpinner.color = UIColor(netHex: 0xAE1522)
        for v in footerView.subviews {
            v.removeFromSuperview()
        }
        pagingSpinner.center = CGPoint(x: footerView.frame.size.width  / 2, y: footerView.frame.size.height / 2)
        footerView.addSubview(pagingSpinner)
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.noMorePackages || self.packages.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: 50, height: self.view.frame.size.height)
    }

}
