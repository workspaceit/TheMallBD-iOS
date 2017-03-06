import UIKit

private let reuseIdentifier = "ItemCell2"

class ItemCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var products: [Product] = []
    var index = 0
    var limit = 10
    var noMoreProducts = false
    
    var product: Product!
    var type: String = "featured"
    var keyword: String = ""
    var category: Categories!
    var manufacturer: Manufacturer!

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func showNoMoreAlert(_ message: String) {
        if self.products.count == 0 {
            self.view.makeToast(message: "No products")
        }
        else if self.products.count >= 6 {
            self.view.makeToast(message: message)
        }
    }
    
    func load(){
        if !noMoreProducts {
            var showLoader = false
            if self.index == 0 {
                showLoader = true
            }
            
            switch (self.type) {
                case "new":
                    ServiceProvider.getProductsByLimit(self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                        if products.count == 0 {
                            self.noMoreProducts = true
                            self.showNoMoreAlert("No more products")
                        }
                        self.products += products
                        self.collectionView!.reloadData()
                    }
                    break
                case "products":
                    ServiceProvider.getProductsByLimit(self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                        if products.count == 0 {
                            self.noMoreProducts = true
                            self.showNoMoreAlert("No more products")
                        }
                        self.products += products
                        self.collectionView!.reloadData()
                    }
                    break
                case "featured":
                    ServiceProvider.getFeaturedProductsByLimit(self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                        if products.count == 0 {
                            self.noMoreProducts = true
                            self.showNoMoreAlert("No more featured products")
                        }
                        self.products += products
                        self.collectionView!.reloadData()
                    }
                    break
                    
                case "discount":
                    ServiceProvider.getSpecialProductsByLimit(self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                        if products.count == 0 {
                            self.noMoreProducts = true
                            self.showNoMoreAlert("No more discounted products")
                        }
                        self.products += products
                        self.collectionView!.reloadData()
                    }
                    break
                case "related":
                    ServiceProvider.getRelatedProducts(product.id,product_category_id: product.categories[0].id, offset: self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                        if products.count == 0 {
                            self.noMoreProducts = true
                            self.showNoMoreAlert("No more related products")
                        }
                        self.products += products
                        self.collectionView!.reloadData()
                    }
                    break
                case "category":
                    ServiceProvider.getProductsByCategory(category.id, offset: self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                        if products.count == 0 {
                            self.noMoreProducts = true
                            self.showNoMoreAlert("No more products")
                        }
                        self.products += products
                        self.collectionView!.reloadData()
                    }
                    break
                case "search":
                    ServiceProvider.searchProductByKeyword(self.keyword, offset: self.index, limit: self.limit, showLoader: showLoader, view: self.view){ (products: [Product]) in
                        if products.count == 0 {
                            self.noMoreProducts = true
                            self.showNoMoreAlert("No more products")
                        }
                        self.products += products
                        self.collectionView!.reloadData()
                    }
                    break
                case "brand":
                    print(manufacturer.name)
                    ServiceProvider.getProductsByBrand(manufacturer.id!, offset: self.index, limit: self.limit, showLoader: true, view: self.view) { (products: [Product]) in
                        if products.count == 0 {
                            self.noMoreProducts = true
                            self.showNoMoreAlert("No more products")
                        }
                        self.products += products
                        self.collectionView?.reloadData()
                    }
                    break
                default:
                    collectionView!.frame.size.height = 140
                    break
            }
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.reloadData()
        self.view.layoutIfNeeded()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = products[(indexPath as NSIndexPath).row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for:indexPath) as! ItemCollectionViewCell
        cell.itemTitle.text = product.title
        
        var prices:[Prices] = product.prices
        var price: Double = 0.0
        if prices.count > 0 {
            price = prices[0].retailPrice
        }
        
        if product.discountActiveFlag {
            let productDiscount = product.discountAmount
            let currentPrice = price - productDiscount
            let attrString0 = NSMutableAttributedString(string: String(price) + " " + Constants.bdtCurrency + "  ")
            attrString0.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attrString0.length-2))
            let attrString1 = NSMutableAttributedString(string: String(currentPrice) + " " + Constants.bdtCurrency)
            let attrString = NSMutableAttributedString()
            attrString.append(attrString0)
            attrString.append(attrString1)
            cell.itemPrice1.attributedText = attrString
        }
        else {
            cell.itemPrice1.text = String(price) + " " + Constants.bdtCurrency
        }

        
//        cell.itemPrice1.text = price + Constants.bdtCurrency
        var pictures: [Picture] = product.pictures
        if pictures.count > 0 {
            cell.itemImage.kf.setImage(
                with: URL(string: Constants.backOffice + "product/general/" + pictures[0].name)!,
                placeholder: nil,
                options: nil,
                completionHandler: nil
            )
        }
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
        let footerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"ItemCollectionFooter", for: indexPath) 
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
        if noMoreProducts || self.products.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: 40, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProDetails", sender: indexPath)
    } 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "ProDetails" {
            let indexPath = sender as! IndexPath
            let dVC = segue.destination as! ProductViewController
            dVC.product = self.products[(indexPath as NSIndexPath).row]
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == self.products.count - 1 {
            self.index  += 1
            load()
        }
    }

}
