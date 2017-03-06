import UIKit


class BrandCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var manufacturers: [Manufacturer] = []
    var offset = 0
    var limit = 18
    var noMoreBrands = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load() {
        var showLoader = false
        if offset == 0 {
            showLoader = true
        }
        ServiceProvider.getManufacturers(offset: self.offset, limit: self.limit,showLoader: showLoader, vc: self, view: self.view) { (manufacturers: [Manufacturer]) in
            if manufacturers.count == 0 {
                self.noMoreBrands = true
                self.view.makeToast(message: "No more brands")
            }
            self.manufacturers += manufacturers
            self.collectionView?.reloadData()
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manufacturers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let manufacturer = self.manufacturers[(indexPath as NSIndexPath).row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandCollectionViewCell
        cell.brandImage.kf.setImage(
            with: URL(string: Constants.backOffice + "manufacturer/" + manufacturer.icon)!,
            placeholder: nil,
            options: nil,
            completionHandler:{(
                image, error, cacheType, imageURL) -> () in
                    if image == nil {
                        cell.brandImage.image = UIImage(named: "no_image")
                    }
            })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProductsByBrand", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (collectionView.frame.width)
        let cellWidth = (screenWidth - 20 - 20) * 0.33
        let cellHeight =  (cellWidth * 0.7)
        return CGSize(width: cellWidth , height: cellHeight)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("rotated")
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductsByBrand" {
            let indexPath = sender as! IndexPath
            let manufacturer =   self.manufacturers[(indexPath as NSIndexPath).row]
            print("selected\(manufacturer.id)")
            let dVC = segue.destination as! ItemCollectionViewController
            dVC.manufacturer = manufacturer
            dVC.type = "brand"
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.manufacturers.count - 1 {
            self.offset  += 1
            self.load()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"BrandCollectionViewFooter", for: indexPath)
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
        if self.noMoreBrands || self.manufacturers.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: 50, height: 40)
    }
    
}
