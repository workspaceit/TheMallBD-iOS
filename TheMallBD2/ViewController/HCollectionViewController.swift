import UIKit
import ObjectMapper
import KVNProgress
import Alamofire

class HCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var productsAr: [Product] = []
    var newProductsIn = false
    var featuredProductsIn = false
    var allProductsIn = false
    var specialProductsIn = false
    var categoriesIn = false
    var noMoreProducts = false
    var offset = 0
    var limit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.walkthrough()
        self.navigationController?.delegate = self
        Utility.loginByAccessKey2(view: self.view) { (success: Bool) in
            self.initialize()
        }
        Utility.setCartFromStorage(vc: self)
    }
    
    
    func walkthrough() {
        let defaults = UserDefaults.standard
        let walkthroughShown = defaults.object(forKey: "walkthrough_shown")
        if walkthroughShown == nil {
//        if 1 == 1{
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "IntroPageViewController") as? IntroPageViewController {
                self.present(pageViewController, animated: true, completion: nil)
            }
        }
    }
    
    func initialize() {
        KVNProgress.show(withStatus: "MallBD is loading. Please wait.")
        loadProducts()
//        loadCategories()
    }
    
    func loadCategories() {
        ServiceProvider.getCategories(false, view: self.view){ (categories: [Categories]) in
            Utility.categories = categories
            self.categoriesIn = true
            self.checkAllResponseIn()
        }
    }
    
    func loadProducts(){
        
        ServiceProvider.getProductsByLimit(0, limit: 10, showLoader: false, view: self.view){ (products: [Product]) in
            Utility.newProducts += products
            self.newProductsIn = true
            self.collectionView?.reloadData()
            self.checkAllResponseIn()
        }
        
        loadCategories()
        
        ServiceProvider.getFeaturedProductsByLimit(0, limit: 10, showLoader: false, view: self.view){ (products: [Product]) in
            Utility.featuredProducts += products
            self.featuredProductsIn = true
            self.collectionView?.reloadData()
            self.checkAllResponseIn()
        }
        
        ServiceProvider.getSpecialProductsByLimit(0, limit: 10, showLoader: false, view: self.view){ (products: [Product]) in
            Utility.discountProducts += products
            self.specialProductsIn = true
            self.collectionView?.reloadData()
            self.checkAllResponseIn()
        }
        
        loadMore()

    }
    
    func loadMore() {
        if !noMoreProducts {
            ServiceProvider.getProductsByLimit(self.offset, limit: self.limit, showLoader: false, view: self.view){ (products: [Product]) in
                if products.count == 0 {
                    self.noMoreProducts = true
                    self.view.makeToast(message: "No more products")
                }
                self.productsAr += products
                self.allProductsIn = true
                self.checkAllResponseIn()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func checkAllResponseIn(){
//        if newProductsIn && featuredProductsIn && specialProductsIn && categoriesIn && allProductsIn {
//            KVNProgress.dismiss()
//            self.view.layoutIfNeeded()
//        }
        
        if newProductsIn && categoriesIn {
            KVNProgress.dismiss()
            self.view.layoutIfNeeded()
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 9
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 8 {
            return self.productsAr.count
        }
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideShowCell", for: indexPath) as! SlideShowCell
            return cell
        }
        else if (indexPath as NSIndexPath).section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            if Utility.categories.count > 0 {
                let catCount = Utility.categories.count
                cell.cat1Title.text = Utility.categories[catCount-1].title
                cell.cat2Title.text = Utility.categories[catCount-2].title
                cell.cat3Title.text = Utility.categories[catCount-3].title
    
                cell.cat1Image.kf.setImage(with: URL(string: Constants.backOffice + "category/banner/" + Utility.categories[catCount-1].banner))
                cell.cat2Image.kf.setImage(with: URL(string: Constants.backOffice + "category/banner/" + Utility.categories[catCount-2].banner))
                cell.cat3Image.kf.setImage(with: URL(string: Constants.backOffice + "category/banner/" + Utility.categories[catCount-3].banner))
                
                cell.cat4.tag = 0
                cell.cat1.tag = catCount - 1
                cell.cat2.tag = catCount - 2
                cell.cat3.tag = catCount - 3
                
                cell.viewController = self
            }
            return cell
        }
        else if (indexPath as NSIndexPath).section == 2 {
            let newProductcell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! PCollectionViewCell
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductCollection") as! ProductCollectionViewController
            viewController.collectionType = "new"
            viewController.products = Utility.newProducts
            self.addChildViewController(viewController)
            viewController.view.frame = newProductcell.bounds
            newProductcell.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
            newProductcell.viewController = viewController
            viewController.reload()
            return newProductcell
        }
        else if (indexPath as NSIndexPath).section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
            return cell
        }
        else if (indexPath as NSIndexPath).section == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! PCollectionViewCell
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductCollection") as! ProductCollectionViewController
            viewController.collectionType = "featured"
            self.addChildViewController(viewController)
            viewController.view.frame = cell.bounds
            cell.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
            cell.viewController = viewController
            viewController.reload()
            return cell
        }
        else if (indexPath as NSIndexPath).section == 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
            return cell
        }
        else if (indexPath as NSIndexPath).section == 6 {
            let packageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageCollectionViewCell", for: indexPath) as! PackageCollectionViewCell
            if packageCollectionCell.viewController == nil {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PackageCollection") as! PackageCollectionViewController
                self.addChildViewController(viewController)
                viewController.view.frame = packageCollectionCell.bounds
                packageCollectionCell.addSubview(viewController.view)
                viewController.didMove(toParentViewController: self)
                packageCollectionCell.viewController = viewController
            }
            return packageCollectionCell
        }
        else if (indexPath as NSIndexPath).section == 7 {
            let discountCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! PCollectionViewCell
            let discountViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductCollection") as! ProductCollectionViewController
            discountViewController.collectionType = "disc"
            discountViewController.view.frame = discountCollectionCell.bounds
            discountCollectionCell.addSubview(discountViewController.view)
            discountViewController.didMove(toParentViewController: self)
            self.addChildViewController(discountViewController)
            discountCollectionCell.viewController = discountViewController
            discountViewController.reload()
            return discountCollectionCell
        }
        else {
            if (indexPath as NSIndexPath).row == productsAr.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for:indexPath) as! ProductCell
                return cell
            }
            else {
                let product = productsAr[(indexPath as NSIndexPath).row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for:indexPath) as! ProductCell
                cell.title.text = product.title
                
                var prices:[Prices] = product.prices
                var price = ""
                if prices.count > 0 {
                    price = String(prices[0].retailPrice)
                }
                cell.price.text = price + " " + Constants.bdtCurrency
                var pictures: [Picture] = product.pictures
                if pictures.count > 0 {
                    cell.image.kf.setImage(
                        with: URL(string: Constants.backOffice + "product/general/" + pictures[0].name)!,
                        placeholder: UIImage(named: "pro"),
                        options: nil,
                        completionHandler: nil
                    )
                }
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width)
        if (indexPath as NSIndexPath).section == 0 {
            if width < 500 {
                return CGSize(width: width, height: 150)
            }
            else {
                return CGSize(width: width, height: 300)
            }
        }
        else if (indexPath as NSIndexPath).section == 1 {
            return CGSize(width: width, height: 100)
        }
        else if (indexPath as NSIndexPath).section == 3 || (indexPath as NSIndexPath).section == 5 {
            return CGSize(width: width, height: 170)
        }
        else if (indexPath as NSIndexPath).section == 8 {
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
        else {
            let width2 = (collectionView.frame.width)
            let cellWidth = width2 * 0.6
            let cellHeight =  cellWidth + 50.0 + 20
            
            return CGSize(width: width2 , height: cellHeight)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView: CollectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"CollectionViewHeader", for: indexPath) as! CollectionViewHeader
                headerView.viewcontroller = self
                if (indexPath as NSIndexPath).section == 2 {
                    headerView.title.text = "NEW PRODUCTS"
                    headerView.moreButton.tag = 2
                    headerView.moreButton.isHidden = false
                }
                else if (indexPath as NSIndexPath).section == 3 {
                    headerView.title.text = "SALE"
                    headerView.moreButton.isHidden = false
                    headerView.moreButton.tag = 3
                    headerView.moreButton.isHidden = true
                }
                else if (indexPath as NSIndexPath).section == 4 {
                    headerView.title.text = "FEATURED PRODUCTS"
                    headerView.moreButton.tag = 4
                    headerView.moreButton.isHidden = false
                }
                else if (indexPath as NSIndexPath).section == 5 {
                    headerView.title.text = "SALE"
                    headerView.moreButton.isHidden = false
                    headerView.moreButton.tag = 5
                    headerView.moreButton.isHidden = true
                }
                else if (indexPath as NSIndexPath).section == 6 {
                    headerView.title.text = "PACKAGE LIST"
                    headerView.moreButton.isHidden = false
                    headerView.moreButton.tag = 6
                }
                else if (indexPath as NSIndexPath).section == 7 {
                    headerView.title.text = "SPECIAL DISCOUNT"
                    headerView.moreButton.isHidden = false
                    headerView.moreButton.tag = 7
                }
                else if (indexPath as NSIndexPath).section == 8 {
                    headerView.title.text = "PRODUCTS"
                    headerView.moreButton.isHidden = false
                    headerView.moreButton.tag = 8
                }
                return headerView
            case UICollectionElementKindSectionFooter:
                let footerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"CollectionViewFooter", for: indexPath)
                let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
                pagingSpinner.startAnimating()
                pagingSpinner.color = UIColor(netHex: 0xAE1522)
                for v in footerView.subviews {
                    v.removeFromSuperview()
                }
                pagingSpinner.center = CGPoint(x: footerView.frame.size.width  / 2, y: footerView.frame.size.height / 2)
                footerView.addSubview(pagingSpinner)
                return footerView
            default:
                let footerView: CollectionViewFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"CollectionViewFooter", for: indexPath) as! CollectionViewFooter
                return footerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 || section == 1 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: 0, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if (section == 8 && (!noMoreProducts || productsAr.count != 0)) {
            return CGSize(width: 0, height: 40)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.reloadData()
    }
    
    @IBAction func goToCategories(_ sender: UIButton) {
        performSegue(withIdentifier: "Categories", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductList2" {
            let button = sender as! UIButton
            let tag = button.tag
            let destinationVC = segue.destination as! ItemCollectionViewController
            switch tag {
                case 2:
                    destinationVC.type = "new"
                    break
                case 4:
                    destinationVC.type = "featured"
                    break
                case 6:
                    destinationVC.type = "package"
                    break
                case 7:
                    destinationVC.type = "discount"
                    break
                case 8:
                    destinationVC.type = "products"
                    break
                default:
                    break
            }
        }
        else if segue.identifier == "ExCat" {
            let row = sender as! Int
            let destinationVC = segue.destination as! ExpandableCategoriesViewController
            destinationVC.preSelectedCategory = Utility.categories[row]
            destinationVC.fromCategoryPage = true
        }
        else if segue.identifier == "ProductDetails2" {
            let indexPath = sender as! IndexPath
            let destinationVC = segue.destination as! ProductViewController
            destinationVC.product =  self.productsAr[(indexPath as NSIndexPath).row]
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let indexSet = IndexSet(integer: 0)
        collectionView?.reloadSections(indexSet)
        self.view.layoutIfNeeded()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 8 {
            performSegue(withIdentifier: "ProductDetails2", sender: indexPath)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 8 {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return UIEdgeInsetsMake(0, 0, 15, 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 8 {
            if (indexPath as NSIndexPath).row == productsAr.count - 1 {
                self.offset += 1
                loadMore()
            }
        }
    }
    
}


extension UIViewController: UINavigationControllerDelegate {
    
    public func goToSearch() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let add = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(UIViewController.goToSearch))
                navigationItem.rightBarButtonItem = add
    }
    
}
