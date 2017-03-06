import UIKit

private let reuseIdentifier = "PackageCell2"

class PackageCollection: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var offset = 0
    var limit = 10
    var packages: [Package] = []
    var noMoreProducts = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load() {
        if !noMoreProducts {
            ServiceProvider.getPackagesByLimit(self.offset, limit: self.limit, showLoader: true, view: self.view) { (packages: [Package]) in
                if packages.count == 0 {
                    self.noMoreProducts = true
                    if self.packages.count > 6 {
                        self.view.makeToast(message: "No more packages")
                    }
                }
                self.packages += packages
                self.collectionView?.reloadData()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.packages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let package = packages[(indexPath as NSIndexPath).row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PackageCell2
        cell.pTitle.text = package.packageTitle
        cell.pPrice.text = String(package.packagePriceTotal) + " " + Constants.bdtCurrency
        
        cell.pImage.kf.setImage(
            with: URL(string: Constants.backOffice + "package/general/" + package.image),
            placeholder: UIImage(named: "pro"),
            options: nil,
            completionHandler: nil
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width)
        if width < 500 {
            let numberOfItemsPerRow:CGFloat = 2.0
            let widthAdjustment = CGFloat(1.0)
            let cellWidth = (width - widthAdjustment) / numberOfItemsPerRow
            let cellHeight =  cellWidth + 50.0
            return CGSize(width: cellWidth , height: cellHeight)
        }
        else {
            let numberOfItemsPerRow:CGFloat = 3.0
            let widthAdjustment =  CGFloat(3.0)
            let cellWidth = (width - widthAdjustment) / numberOfItemsPerRow
            let cellHeight =  cellWidth + 50.0
            return CGSize(width: cellWidth , height: cellHeight)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"PackageCollectionFooter", for: indexPath)
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
        var height: CGFloat = 0.0
        if !noMoreProducts {
            height = 30.0
        }
        else {
            height = 0.0
        }
        return CGSize(width: 0, height: height)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.reloadData()
        self.view.layoutIfNeeded()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PackageDetails2", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PackageDetails2" {
            let indexPath = sender as! IndexPath
            let package = self.packages[(indexPath as NSIndexPath).row]
            let dVC = segue.destination as! PackageViewController
            dVC.package = package
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == self.packages.count - 1 {
            self.offset  += 1
            load()
        }
    }

}
