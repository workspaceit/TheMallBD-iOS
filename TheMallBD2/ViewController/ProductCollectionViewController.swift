import UIKit
import KVNProgress
import ObjectMapper
import Kingfisher

class ProductCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var productColl: UICollectionView!
    @IBOutlet weak var prodcutCollHeight: NSLayoutConstraint!
    
    var collectionType: String = "default"
    var products: [Product] = []
    var index = 0
    var limit = 10
    var noMoreProducts = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productColl.dataSource = self
        self.productColl.delegate = self
        self.initialize()
        let width = productColl.frame.width
        let cellWidth = (width * 0.6)
        let cellHeight =  cellWidth + 50.0 + 10.0
        self.prodcutCollHeight.constant = cellHeight
    }
    
    func initialize() {
        self.loadData()
    }
    
    func fetchMoreData(){
        if !noMoreProducts {
            if self.collectionType == "new" {
                ServiceProvider.getProductsByLimit(self.index, limit: self.limit, showLoader: false, view: self.view){ (products: [Product]) in
                    if products.count == 0 {
                        self.noMoreProducts = true
                        
                        self.view.makeToast(message: "No more new products")
                    }
                    self.products += products
                    Utility.newProducts += products
                    self.productColl.reloadData()
                }
            }
            else if self.collectionType == "featured" {
                ServiceProvider.getFeaturedProductsByLimit(self.index, limit: self.limit, showLoader: false, view: self.view){ (products: [Product]) in
                    if products.count == 0 {
                        self.noMoreProducts = true
                        self.view.makeToast(message: "No more featured products")
                    }
                    self.products += products
                    Utility.featuredProducts += products
                    self.productColl.reloadData()
                }
            }
            else if self.collectionType == "disc" {
                ServiceProvider.getSpecialProductsByLimit(self.index, limit: self.limit, showLoader: false, view: self.view){ (products: [Product]) in
                    if products.count == 0 {
                        self.noMoreProducts = true
                        self.view.makeToast(message: "No more discount products")
                    }
                    self.products += products
                    Utility.discountProducts += products
                    self.productColl.reloadData()
                }
            }
        }
    }
    
    func loadData(){
        if self.collectionType == "new" {
            self.products = Utility.newProducts
        }
        else if self.collectionType == "featured" {
            self.products = Utility.featuredProducts
            
        }
        else if self.collectionType == "disc" {
            self.products = Utility.discountProducts
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func reload() {
        self.productColl.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProCell",for:indexPath) as! ProCell
        
        var product: Product?
        if (indexPath as NSIndexPath).row == Utility.newProducts.count {
            product = nil
        }
        else {
            product = products[(indexPath as NSIndexPath).row]
        }
        if (product != nil) {
            cell.title.text = product!.title
            var prices:[Prices] = product!.prices
            var price: Double = 0.0
            if prices.count > 0 {
                price = prices[0].retailPrice
            }
            var pictures: [Picture] = product!.pictures
            cell.image.image = nil
            if pictures.count > 0 {
                if (indexPath as NSIndexPath).row == 0 {
                    print(Constants.backOffice+"product/general/"+pictures[0].name)
                }
                cell.image.kf.setImage(with: URL(
                    string: Constants.backOffice+"product/general/"+pictures[0].name)!,
                                       placeholder: nil,
                                       options: nil,
                    completionHandler:{(
                        image, error, cacheType, imageURL) -> () in
                        if image == nil {
                            cell.image.image = UIImage(named: "no_image")
                        }
                })                  
//                cell.image.kf_setImageWithURL(NSURL(string: Constants.backOffice+"product/general/"+pictures[0].name)!)
            }
            else {
                cell.image.image = UIImage(named: "no_image")
            }
            if product!.discountActiveFlag {
                let productDiscount = product!.discountAmount
                let currentPrice = price - productDiscount
                let attrString0 = NSMutableAttributedString(string: String(price) + " " + Constants.bdtCurrency + "  ")
                attrString0.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attrString0.length-2))
                let attrString1 = NSMutableAttributedString(string: String(currentPrice) + " " + Constants.bdtCurrency)
                let attrString = NSMutableAttributedString()
                attrString.append(attrString0)
                attrString.append(attrString1)
                cell.price.attributedText = attrString
            }
            else {
                cell.price.text = String(price) + " " + Constants.bdtCurrency
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowProduct", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = products.count
        if (indexPath as NSIndexPath).row == count - 1 {
            self.index = count / 10
            print("printing \(self.index)")
            self.fetchMoreData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowProduct") {
            let productViewController = segue.destination as! ProductViewController
            productViewController.product = products[((sender as! NSIndexPath).row)]
            let backItem = UIBarButtonItem()
            backItem.title = "Something Else"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width)
        let cellWidth = (width * 0.6)
        let cellHeight =  cellWidth + 50.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"ProductCollectionViewFooter", for: indexPath)
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
        if self.noMoreProducts || self.products.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: 60, height: self.view.frame.size.height)
    }

}
