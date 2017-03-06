import UIKit
import ImageSlideshow

class SlideShowCell: UICollectionViewCell {
    
    @IBOutlet weak var slideShow: ImageSlideshow!
    var imageSources:[ImageSource] = []
    var vc: UIViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
        slideShow.backgroundColor = UIColor.white
        slideShow.slideshowInterval = 5.0
        slideShow.pageControlPosition = PageControlPosition.insideScrollView
        slideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideShow.pageControl.pageIndicatorTintColor = UIColor.red
        slideShow.contentScaleMode = UIViewContentMode.scaleToFill
        loadImages()
    }
    
    func loadImages() {
        ServiceProvider.getBanners(false, view: nil) { (images: NSArray) in
            
            for (index, singleImage) in images.enumerated() {
                let imageView:UIImageView! = UIImageView()
                let sImage = singleImage as! NSDictionary
                let imageName = sImage["image"]! as! String
                imageView.kf.setImage(
                    with: URL(string: Constants.backOffice + "banner/" + imageName)!,
                    placeholder: nil,
                    options: nil,
                    completionHandler:{(
                        image, error, cacheType, imageURL) -> () in
                        if image != nil {
                            self.imageSources.append(ImageSource(image: imageView.image!))
                        }
                        if index == images.count - 1 {
                            self.loadSlideshow()
                        }
                    })
                }
            }
        
    }
    
    func loadSlideshow() {
        self.slideShow.setImageInputs(self.imageSources)
    }
    
}
