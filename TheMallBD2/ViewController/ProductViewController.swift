import UIKit
import ImageSlideshow
import Cosmos
import DropDown
import ObjectMapper

class ProductViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var previousPrice: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var prpLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var relatedProductsContainer: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var quantityDropdown: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewsLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewContainer: UIView!
    @IBOutlet weak var showReviewButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var showReviewButton: UIButton!
    @IBOutlet weak var loadMoreRelatedButton: UIButton!
    @IBOutlet weak var relatedLabelHeightCons: NSLayoutConstraint!
    @IBOutlet weak var relatedContainerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var relaedButtonHeightCons: NSLayoutConstraint!
    
    
    var dropDown = DropDown()
    var dop: [String] = []
    var product: Product!
    var productId: Int!
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeFieldsEmpty()
        if self.type == "toBeLoaded" {
            ServiceProvider.getProductById(productId, showLoader: true, view: self.view) { (product: Product?) in
                self.product = product
                self.intitialize()
            }
        }
        else {
            self.intitialize()
        }
    }
    
    @IBAction func writeReview(_ sender: AnyObject) {
        
    }
    
    func showDropDown(){
        dropDown.show()
    }
    
    func showRating(){
        ratingView.settings.fillMode = .half
        ratingView.rating = Double(self.product.avgRating)
        ratingView.isUserInteractionEnabled = false
    }
    
    func initializeDropdown(){
        self.dropDown.anchorView = quantityDropdown
        self.dropDown.dataSource = dop
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.quantityLabel.text = item
        }
    }
    
    func hideDiscount(){
        self.prpLabel.isHidden = true
        self.discountLabel.isHidden = true
        self.previousPrice.isHidden = true
        self.discount.isHidden = true
    }
    
    func showDiscount(){
        self.prpLabel.isHidden = false
        self.discountLabel.isHidden = false
        self.previousPrice.isHidden = false
        self.discount.isHidden = false
    }
    
    func makeFieldsEmpty(){
        self.hideDiscount()
        self.productTitle.text = ""
        self.productDescription.text = ""
        self.price.text = ""
        self.previousPrice.text = ""
        self.discount.text = ""
        quantityLabel.text = "0"
    }
    
    func intitialize(){
        self.hideDiscount()
        self.productTitle.text = self.product.title
        self.productDescription.text = self.product.productDescriptionMobile
        var prices:[Prices] = product.prices
        var price: Double = 0
        var prp: Double = 0
        var productDiscount: Double = 0
        if prices.count > 0 {
            let priceObj = prices[0]
            prp = priceObj.retailPrice
            if self.product.discountActiveFlag {
                price =  prp - self.product.discountAmount
                productDiscount = self.product.discountAmount
            }
            else {
                price = prp
            }
            self.showRating()
            self.loadRelatedProducts()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductViewController.showDropDown))
            self.quantityDropdown.addGestureRecognizer(tapGesture)
            self.loadReviews()
        }
        
        self.price.text = String(price) + " " + Constants.bdtCurrency
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(prp) + " " + Constants.bdtCurrency)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        self.previousPrice.attributedText = attributeString
        self.discount.text = String(productDiscount) + " " + Constants.bdtCurrency
        
        let quantity: Int  = Int(product.quantity)!
        let minimumOrderQuantity = product.minimumOrderQuantity
        
//        print("quantity\(quantity)")
//        print("min order quantity\(minimumOrderQuantity)")
        
        if quantity > 0 {
            for q in minimumOrderQuantity ..< quantity + 1 {
                dop.append(String(q))
            }
            quantityLabel.text = String(minimumOrderQuantity)
        }
        else {
            quantityLabel.text = "0"
            addToCartButton.setTitle("Product not available", for: UIControlState())
            addToCartButton.isUserInteractionEnabled = false
        }
        
        if self.product.discountActiveFlag {
            self.showDiscount()
        }
        
        let pictures: [Picture] = product.pictures
        self.slideShow.backgroundColor = UIColor.white
        self.slideShow.slideshowInterval = 5.0
        self.slideShow.pageControlPosition = PageControlPosition.insideScrollView
        self.slideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        self.slideShow.pageControl.pageIndicatorTintColor = UIColor.red

        
        var images:[ImageSource]! = []
        if pictures.count > 0 {
            for picture in pictures {
                let imageView:UIImageView! = UIImageView()
                imageView.kf.setImage(
                    with: URL(string: Constants.backOffice + "product/general/" + picture.name)!,
                    placeholder: nil,
                    options: nil,
                    completionHandler:{(
                        image, error, cacheType, imageURL) -> () in
                            if image != nil {
                                images.append(ImageSource(image: imageView.image!))
                            }
                            else {
                                images.append(ImageSource(image: UIImage(named: "no_image")!))
                        }
                })
            }
            slideShow.setImageInputs(images)
        }
        else {
            images.append(ImageSource(image: UIImage(named: "no_image")!))
            slideShow.setImageInputs(images)
        }
        initializeDropdown()
    }
    
    
    @IBAction func addToCart(_ sender: AnyObject) {
        var message: String = ""
        let minimumOrderQuantity = product.minimumOrderQuantity
        let quantity = Int(product.quantity)
        let q: Int = Int(quantityLabel.text!)!
        var alreadyExists = false
        let productsInCart: [CartProductCell] = Utility.shoppingCart.productCell
        for proCell: CartProductCell in productsInCart {
            if proCell.product.id == product.id {
                if (q + proCell.quantity <= quantity!) {
                    proCell.quantity = q + proCell.quantity
                    message = "Product already exixts. Quantity updated."
                }
                else {
                    proCell.quantity = quantity!
                    message = "Maximum available quantity of this product already added in your cart"
                }
                alreadyExists = true
                break
            }
        }
        if !alreadyExists {
            let productCell: CartProductCell = CartProductCell(id: product.id, product: product, quantity: q)
            Utility.shoppingCart.productCell.append(productCell)
            message = "Product Added to Cart"
        }
        
        Utility.shoppingCart.update()
        let cartItemCount = Utility.shoppingCart.mallBdPackageCell.count + Utility.shoppingCart.productCell.count
        var badge: String? = nil
        if cartItemCount > 0 {
            badge = String(cartItemCount)
        }
        self.tabBarController?.tabBar.items?[1].badgeValue = badge
        
        showMessage("Added", message: message)
        
    }
   
    func showMessage(_ title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = UIColor(netHex: 0xAE1522)
        let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
        })
        alertController.addAction(continueAction)
        let okAction = UIAlertAction(title: "Checkout", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
            
            self.tabBarController?.selectedIndex = 1
            
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addToWishList(_ sender: UIButton) {
        ServiceProvider.addProductToWishlist(self.product.id, vc: self, showLoader: true, view: self.view){ (success: Bool) in
            if success {
                self.view.makeToast(message: "Product added to Wishlist")
            }
            else {
//                self.view.makeToast(message: "Something went wrong. Please try again.")
            }
        }
    }
    
    @IBAction func wirteReview(_ sender: AnyObject) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "ProductReviewModal") as! ProductReviewViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.formSheet
        let pre = vc.presentationController
        vc.product = self.product
        pre?.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.formSheet
    }
    
    @IBOutlet weak var writeReview: UIButton!
    
    @IBAction func loadMoreRelatedProducts(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowRelatedProducts", sender: nil)
    }
    
    @IBAction func showAllReviews(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowAllReviews", sender: sender)
    }
    
    func loadRelatedProducts(){
        if self.product.categories != nil {
            if self.product.categories.count > 0 {
                let productTableVC: ProductTableViewController = storyboard?.instantiateViewController(withIdentifier: "ProductTableViewController") as! ProductTableViewController
                ServiceProvider.getRelatedProducts(product.id,product_category_id: product.categories[0].id, offset: 0, limit: 3, showLoader: false, view: self.view){ (products: [Product]) in
                    if products.count > 0 {
                        productTableVC.products = products
                        productTableVC.type = "related_three"
                        
                        self.addChildViewController(productTableVC)
                        productTableVC.view.frame = self.relatedProductsContainer.bounds
                        self.relatedProductsContainer.addSubview(productTableVC.view)
                        self.containerHeightConstraint.constant = 150 * CGFloat(products.count)
                        self.contentViewHeightConstraint.constant = ((self.contentViewHeightConstraint.constant + (150 * CGFloat(products.count))) - 150)
                        self.view.layoutIfNeeded()
                    }
                    else {
                        self.adjustForNoRelatedProducts()
                    }
                }
            }
            else {
                self.adjustForNoRelatedProducts()
            }
        }
        else {
            self.adjustForNoRelatedProducts()
        }
    }
    
    func adjustForNoRelatedProducts(){
        self.relaedButtonHeightCons.constant = 0.0
        self.relatedLabelHeightCons.constant = 0.0
        self.relatedContainerHeightCons.constant = 0.0
        self.contentViewHeightConstraint.constant = self.contentViewHeightConstraint.constant - 150
        self.view.layoutIfNeeded()
    }
    
    func loadReviews() {
        let reviewTableVC: ReviewViewController = storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        ServiceProvider.getReviewsByProduct(self.product.id, offset: 0, limit: 3, showLoader: false, view: self.view) { (reviews: [Review]) in
            reviewTableVC.reviews = reviews
            reviewTableVC.type = "review_3"
            self.reviewContainer.addSubview(reviewTableVC.view)
            self.addChildViewController(reviewTableVC)
            if reviews.count > 0 {
                self.reviewsContainerHeightConstraint.constant = 120 * CGFloat(reviews.count)
                self.contentViewHeightConstraint.constant = ((self.contentViewHeightConstraint.constant + (120 * CGFloat(reviews.count))) - 120)
            }
            else {
                self.reviewsContainerHeightConstraint.constant = 0.0
                self.reviewsLabelHeightConstraint.constant = 0.0
                self.showReviewButtonHeight.constant = CGFloat(0.0)
                self.showReviewButton.isHidden = true
                self.contentViewHeightConstraint.constant = self.contentViewHeightConstraint.constant - 250
            }
            self.view.layoutIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowRelatedProducts") {
            let productTableVC = segue.destination as! ItemCollectionViewController
            productTableVC.type = "related"
            productTableVC.product = self.product
        }
        else if segue.identifier == "ShowAllReviews" {
            let reviewVC = segue.destination as! ReviewViewController
            reviewVC.type = "reviews"
            reviewVC.product = self.product
        }
    }
    
}
