import UIKit
import KVNProgress
import ObjectMapper
import Kingfisher

class VerticalProductCollectionController: UICollectionViewController {
    
    
    
    var products: [Product] = []
    var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("samrt:" + String(describing: collectionView!.frame.width))
        
        
        
        var leftAndRightPaddings: CGFloat = 40.0
        var numberOfItemsPerRow: CGFloat = 4.0
        var heightAdjustments: CGFloat = 8.0
        
        if collectionView!.frame.width < 500 {
            leftAndRightPaddings = 4.0
            numberOfItemsPerRow = 2.0
            heightAdjustments = 1.0
        }
        
        
        let width = (collectionView!.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + heightAdjustments)
        
        //self.scrollView.scrollEnabled = false

//        KVNProgress.show()
        ServiceProvider.getProductsByLimit(0, limit: 10, showLoader: false, view: self.view){ (products: [Product]) in
//            KVNProgress.dismiss()
            self.products = products
            self.collectionView?.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProCell",for:indexPath) as! ProductCollectionViewCell
        let product: Product = products[(indexPath as NSIndexPath).row]
//        cell.title.text = product.title
//        var prices:[Prices] = product.prices
//        var price: String
//        if prices.count > 0 {
//            price = String(prices[0].retailPrice)
//        }
//        cell.price.text = price
        let pictures: [Picture] = product.pictures
        print(pictures.count)
        if pictures.count > 0 {
//            cell.image.kf_setImageWithURL(NSURL(string: Constants.backOffice+"product/general/"+pictures[0].name)!)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cskdhfhsdf")
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        print("index="+String((indexPath as NSIndexPath).row))
        if (indexPath as NSIndexPath).row == products.count - 1 {
            
        }
        
//        if indexPath.row == 5 {
//            scrollView.scrollEnabled = false
//        }
//        
//        if indexPath.row == 1 {
//            scrollView.scrollEnabled = true
//        }
    }

}
