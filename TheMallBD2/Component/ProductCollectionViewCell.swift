import UIKit

class ProductCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var viewController: UIViewController! = nil
    
    @IBOutlet weak var productCollection: UICollectionView!
    var products: [Product] = []
    var collectionType: String = "new"
    var index: Int = 0
    var limit: Int = 10
    
    override func awakeFromNib() {
        self.productCollection.dataSource = self
        self.productCollection.delegate = self
    }
    
    func load(){
        print("loading")
        
        if self.collectionType == "new" {
            print("NEW")
            ServiceProvider.getProductsByLimit(self.index, limit: self.limit, showLoader: false, view: self.viewController.view){ (products: [Product]) in
                self.products += products
                print(self.products.count)
                self.productCollection.reloadData()
            }
        }
        else if self.collectionType == "featured" {
            print("FEAT")
            ServiceProvider.getFeaturedProductsByLimit(self.index, limit: self.limit, showLoader: false, view: self.viewController.view){ (products: [Product]) in
                self.products += products
                print(products.count)
                
                self.productCollection.reloadData()
            }
        }
        else if self.collectionType == "discount" {
            print("DISC")
            ServiceProvider.getSpecialProductsByLimit(self.index, limit: self.limit, showLoader: false, view: viewController.view){ (products: [Product]) in
                self.products += products
                print(products.count)
                
                self.productCollection.reloadData()
            }
        }
    }

    
    func reloadData(){
        productCollection.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PCell",for:indexPath) as! PCell
        let product: Product = products[(indexPath as NSIndexPath).row]
        cell.title.text = product.title
        var prices:[Prices] = product.prices
        var price = ""
        if prices.count > 0 {
            price = String(prices[0].retailPrice)
        }
        cell.price.text = price
        var pictures: [Picture] = product.pictures
        print(pictures.count)
        if pictures.count > 0 {
            cell.image.kf.setImage(with: URL(string: Constants.backOffice + "product/general/" + pictures[0].name)!)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == products.count - 1 {
            print(self.collectionType)
            self.index += 1
            self.load()
        }
    }
    
}
