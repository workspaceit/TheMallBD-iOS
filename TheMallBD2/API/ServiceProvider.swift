import UIKit
import ObjectMapper
import KVNProgress
import Alamofire

class ServiceProvider: NSObject {
    
    class func getProductsByLimit(_ offset: Int, limit: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ products: [Product]) -> Void) {
        HttpClient.postRequest("api/products/all/show",param:["shop_id":Constants.shopId as AnyObject,"offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            
            let response: ProductResponse = Mapper<ProductResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Data Received" {
                    let products: [Product] = []
                    onCompletion(products)
                }
                else {
                    print("Soemthing went wrong")
                }
            }
            else{
                let products: [Product] = response.responseData!
                onCompletion(products)
            }
        }
    }
    
    class func getFeaturedProductsByLimit(_ offset: Int, limit: Int, showLoader: Bool,view: UIView?, onCompletion: @escaping (_ products: [Product]) -> Void) {
        HttpClient.postRequest("api/products/featured/show",param:["shop_id":Constants.shopId as AnyObject,"offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let response: ProductResponse = Mapper<ProductResponse>().map(JSONObject: result)!
            print(response.responseStat.isLogin)
            print(response.responseStat.msg)
            print(response.responseStat.status)
            if (response.responseStat.status == true) {
                let products: [Product] = response.responseData!
                onCompletion(products)
            }
            else {
                if response.responseStat.msg == "No Data Received" {
                    let products: [Product] = []
                    onCompletion(products)
                }
                else {
                    print("Soemthing went wrong")
                }
            }
        }
    }
    
    class func getSpecialProductsByLimit(_ offset: Int, limit: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ products: [Product]) -> Void) {
        HttpClient.postRequest("api/products/special/show",param:["shop_id":Constants.shopId as AnyObject,"offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let response: ProductResponse = Mapper<ProductResponse>().map(JSONObject: result)!
            if (!response.responseStat.status) {
                if response.responseStat.msg == "No Data Received" {
                    let products: [Product] = []
                    onCompletion(products)
                }
                else {
                    print("Soemthing went wrong")
                }
            }
            else{
                let products: [Product] = response.responseData!
                onCompletion(products)
            }
        }
    }
    
    class func getRelatedProducts(_ product_id: Int, product_category_id: Int, offset: Int, limit: Int, showLoader: Bool, view: UIView, onCompletion: @escaping (_ products: [Product]) -> Void) {
        HttpClient.postRequest("api/relatedproduct/get",param:["shop_id":Constants.shopId as AnyObject,"product_id": product_id as AnyObject, "product_category_id": product_category_id as AnyObject, "offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let response: ProductResponse = Mapper<ProductResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Related Product Found" {
                    let products: [Product] = []
                    onCompletion(products)
                }
            }
            else {
                let products: [Product] = response.responseData!
                onCompletion(products)
            }
        }
    }
    
    class func getProductsByCategory(_ category: Int, offset: Int, limit: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ products: [Product]) -> Void) {
        HttpClient.postRequest("api/product/category",param:["shop_id":Constants.shopId as AnyObject,"category": category as AnyObject, "offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let response: ProductResponse = Mapper<ProductResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                print(response.responseStat.msg)
                if response.responseStat.msg == "No Data received" {
                    onCompletion([])
                }
            }
            else{
                let products: [Product] = response.responseData!
                onCompletion(products)
            }
        }
    }
    
    
    class func getPackagesByLimit(_ offset: Int, limit: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ packages: [Package]) -> Void) {
        HttpClient.postRequest("api/package/all/mobile",param:["shop_id":Constants.shopId as AnyObject,"offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let response: PackageResponse = Mapper<PackageResponse>().map(JSONObject: result)!
            if response.responseStat.status == true {
                let packages: [Package] = response.responseData
                onCompletion(packages)
            }
            else {
                if response.responseStat.msg == "No Package Found" {
                    let packages: [Package] = []
                    onCompletion(packages)
                }
                else {
                    print("Soemthing went wrong")
                }
            }
        }
    }
    
    
    class func login(_ email: String, password: String, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ loginResponse: LoginResponse) -> Void) {
        HttpClient.postRequest("login",param:["email" :email as AnyObject,"password":password as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let loginResponse: LoginResponse = Mapper<LoginResponse>().map(JSONObject: result)!
            onCompletion(loginResponse)
        }
    }
    
    class func register(_ firstName: String, lastname: String, phone: String, email: String, password: String, confirmPassword: String, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ response: NSDictionary) -> Void) {
        HttpClient.postRequest("api/registration/register",param:["first_name": firstName as AnyObject, "last_name": lastname as AnyObject, "phone": phone as AnyObject, "email" :email as AnyObject,"password":password as AnyObject, "confirm_password": confirmPassword as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let dict = result as! NSDictionary
            onCompletion(dict)
        }
    }
    
    class func getCategories(_ showLoader: Bool, view: UIView?, onCompletion: @escaping (_ categories: [Categories]) -> Void) {
        HttpClient.postRequest("api/category/parents/show",param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let response: Response1 = Mapper<Response1>().map(JSONObject: result)!
            if !response.responseStat.status {
                print("Error")
            }
            else {
//                let categories: [Categories] = Mapper<Categories>().mapDictionary(JSONObject: response.responseData);
                let categories: [Categories] = Mapper<Categories>().mapArray(JSONArray: response.responseData as! [[String : Any]])!
                onCompletion(categories)
            }
        }
    }
    
    class func updateAccountInfo(_ firstName: String, lastName: String, phone: String, address: String, city: String, zip: String, country: String, showLoader: Bool, view: UIView, onCompletion: @escaping (_ userInfo: UserInfo?) -> Void){
        HttpClient.postRequest1("api/profile/update", param:["first_name": firstName as AnyObject, "last_name": lastName as AnyObject, "phone": phone as AnyObject, "address": address as AnyObject, "city": city as AnyObject, "zip_code": zip as AnyObject, "country": country as AnyObject], showLoader: showLoader, view: view) {
            (result: AnyObject) in
            print(result)
            let userResponse: UserResponse = Mapper<UserResponse>().map(JSONObject: result)!
            if userResponse.responseStat.status == true {
                let userInfo: UserInfo = userResponse.responseData!
                onCompletion(userInfo)
            }
            else{
                view.makeToast(message: userResponse.responseStat.msg)
                onCompletion(nil)
            }
        }
    }
    
    class func getReviewsByProduct(_ product_id: Int, offset: Int, limit: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ reviews: [Review]) -> Void) {
        HttpClient.postRequest("api/product/review",param:["shop_id":Constants.shopId as AnyObject,"product_id": product_id as AnyObject, "offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
//            print(result)
            let response: ReviewResponse = Mapper<ReviewResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Review Found" {
                    onCompletion([])
                }
            }
            else{
                let reviews: [Review] = response.responseData!
                onCompletion(reviews)
            }
        }
    }
    
    class func searchProductByKeyword(_ keyword: String, offset: Int, limit: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ products: [Product]) -> Void) {
        HttpClient.postRequest("api/products/all/search",param:["shop_id":Constants.shopId as AnyObject,"keyword": keyword as AnyObject, "offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            let response: ProductResponse = Mapper<ProductResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Products Found" {
                    onCompletion([])
                }
            }
            else{
                let products: [Product] = response.responseData!
                onCompletion(products)
            }
        }
    }
    
    class func searchProductSuggestionByKeyword(_ keyword: String, limit: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ products: [ProductSuggestion]) -> Void) {
        HttpClient.postRequest("api/products/all/search/suggestion",param:["shop_id":Constants.shopId as AnyObject,"keyword": keyword as AnyObject, "limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            print(result!)
            let response: ProductSuggestionResponse = Mapper<ProductSuggestionResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Products Found" {
                    onCompletion([])
                }
            }
            else{
                let products: [ProductSuggestion] = response.responseData!
                onCompletion(products)
            }
        }
    }
    
    class func getProductById(_ product_id: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ product: Product?) -> Void) {
        HttpClient.postRequest("api/products/findbyid",param:["shop_id":Constants.shopId as AnyObject,"id": product_id as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            print(result!)
            let response: SingleProductResponse = Mapper<SingleProductResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Product Found" {
                    onCompletion(nil)
                }
            }
            else{
                let product: Product = response.responseData!
                onCompletion(product)
            }
        }
    }
    
    class func addProductToWishlist(_ product_id: Int, vc: UIViewController, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ success: Bool) -> Void) {
        HttpClient.postRequest("api/customer/wishlist/add",param:["shop_id":Constants.shopId as AnyObject,"product_id": product_id as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            print(result!)
            let response: Response1 = Mapper<Response1>().map(JSONObject: result)!
            if !response.responseStat.status {
                
                onCompletion(false)
                vc.view.makeToast(message: response.responseStat.msg!)
            }
            else {
                onCompletion(true)
            }
        }
    }
    
    class func getWishList(_ showLoader: Bool, view: UIView, onCompletion: @escaping (_ products: [Product]) -> Void) {
        HttpClient.getRequest("api/customer/wishlist/all", param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject) in
            print(result)
            let response: ProductResponse = Mapper<ProductResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Products Found" {
                    onCompletion([])
                }
                else {
                    view.makeToast(message: response.responseStat.msg!)
                }
            }
            else {
                let products: [Product] = response.responseData!
                onCompletion(products)
            }
        }
        
    }
    
    class func getOrders(_ showLoader: Bool,view: UIView?, onCompletion: @escaping (_ orders: [Order]) -> Void) {
        HttpClient.postRequest("api/order/getbyuser/mobile", param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
//            print(result)
            let response: OrdersResponse = Mapper<OrdersResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Orders Found" {
                    onCompletion([])
                }
            }
            else {
                let orders: [Order] = response.responseData!
                onCompletion(orders)
            }
        }
        
    }
    
    class func getDeliveryMethods(_ showLoader: Bool, view: UIView, onCompletion: @escaping (_ deliveryMethods: [DeliveryMethod]) -> Void) {
        HttpClient.getRequest("api/deliverymethod/all", param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
            let response: DeliveryMethodResponse = Mapper<DeliveryMethodResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Method Found" {
                    onCompletion([])
                }
            }
            else {
                let deliveryMethods: [DeliveryMethod] = response.responseData!
                onCompletion(deliveryMethods)
            }
        }
    }
    
    class func getDistricts(_ showLoader: Bool, view: UIView, onCompletion: @escaping (_ districts: [District]) -> Void) {
        HttpClient.getRequest("api/districts/get", param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
            let response: DistrictResponse = Mapper<DistrictResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No City Found" {
                    onCompletion([])
                }
            }
            else {
                let districts: [District] = response.responseData!
                onCompletion(districts)
            }
        }
    }
    
    class func getCustomerDiscount(_ showLoader: Bool, view: UIView, onCompletion: @escaping (_ customerDiscountResponse: CustomerDiscountResponse) -> Void) {
        HttpClient.getRequest("api/getcustomerpurchasediscount", param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
            print(result!)
            let response: CustomerDiscountResponse = Mapper<CustomerDiscountResponse>().map(JSONObject: result)!
            onCompletion(response)
        }
    }
    
    class func getPaymentMethods(_ showLoader: Bool, view: UIView, onCompletion: @escaping (_ paymentMethods: [PaymentMethod]) -> Void) {
        HttpClient.getRequest("api/paymentmethods/all", param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
            let response: PaymentMethodResponse = Mapper<PaymentMethodResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Method Found" {
                    onCompletion([])
                }
            }
            else {
                let paymentMethods: [PaymentMethod] = response.responseData!
                onCompletion(paymentMethods)
            }
        }
    }
    
    class func order(_ checkout: Checkout, vc: UIViewController, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ payment: Payment) -> Void) {
        let cartString = Mapper().toJSONString(Utility.shoppingCart, prettyPrint: false)
        let shopId = Constants.shopId as AnyObject
        let firstName = checkout.first_name as AnyObject
        let lastName = checkout.last_name as AnyObject
        let email = checkout.email as AnyObject
        let phone = checkout.phone as AnyObject
        let address = checkout.address as AnyObject
        let city = checkout.city as AnyObject
        let orderFrom = checkout.order_from as AnyObject
        let invoice_address = checkout.invoice_address as AnyObject
        let shippingFirstname = checkout.shipping_firstname as AnyObject
        let shippingLastname = checkout.shipping_lastname as AnyObject
        let shippingPhone = checkout.shipping_phone as AnyObject
        let shippingAddress = checkout.shipping_address as AnyObject
        let shippingCity = checkout.shipping_city as AnyObject
        let deliveryMethodId = checkout.delivery_method_id! as AnyObject
        let paymentMethodId = checkout.payment_method_id! as AnyObject
        let currencyId = checkout.currency_id! as AnyObject
        let voucherDiscountDetails = checkout.voucherDiscountDetails as AnyObject
        let customerDiscount = checkout.customerDiscount as AnyObject
        let customerDiscountDetails = checkout.customerDiscountDetails as AnyObject
        let shoppingCart = cartString! as AnyObject
        
        
        print("customer discount \(customerDiscount)")
        
        let parameters: [String: AnyObject] = [
            "shop_id": shopId,
            
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "phone": phone,
            "address": address,
            "city": city,
            
            "order_from": orderFrom,
            
            "invoice_address": invoice_address,
            "shipping_firstname": shippingFirstname,
            "shipping_lastname": shippingLastname,
            "shipping_phone": shippingPhone,
            "shipping_address": shippingAddress,
            "shipping_city": shippingCity,
            
            "delivery_method_id": deliveryMethodId,
            "payment_method_id": paymentMethodId,
            "currency_id": currencyId,
            
            "voucherDiscountDetails": voucherDiscountDetails,
            "customerDiscount": customerDiscount,
            "customerDiscountDetails": customerDiscountDetails,
            
            "shopping_cart": shoppingCart
        ]

        HttpClient.postRequest("api/checkout/submit", param: parameters, showLoader: showLoader, view: view){ (result: AnyObject?) in
            print(result!)
            let response: PaymentResponse = Mapper<PaymentResponse>().map(JSONObject: result)!
            
            if !response.responseStat.status {
                vc.view.makeToast(message: response.responseStat.msg!)
            }
            else {
                let payment: Payment = response.responseData!
                onCompletion(payment)
            }
        }
    }
    
    class func BkashPayment(_ unioque_code: String, mobileNumber: String, transactionId: String, showLoader: Bool, vc: UIViewController, view: UIView?, onCompletion: @escaping (_ bkashResponse: AnyObject?) -> Void) {
        HttpClient.postRequest("api/bkash-data-process", param:["shop_id":Constants.shopId as AnyObject, "unique_code": unioque_code as AnyObject, "mobileNumber": mobileNumber as AnyObject, "transactionId": transactionId as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
            print(result!)
            let response: Response1 = Mapper<Response1>().map(JSONObject: result)!
            if !response.responseStat.status {
                Utility.showValidationError("Error", message: response.responseStat.msg, viewController: vc)
            }
            else {
                Utility.showValidationError("Success", message: response.responseStat.msg, viewController: vc)
                onCompletion(response.responseData)
            }
        }
        
    }
    
    class func walletMixPayment(_ orderId: Int, showLoader: Bool, vc: UIViewController, view: UIView?, onCompletion: @escaping (_ response: AnyObject?) -> Void) {
        HttpClient.postRequest("api/walletmix", param:["shop_id":Constants.shopId as AnyObject, "order_id": orderId as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
            print(result!)
            let response: Response1 = Mapper<Response1>().map(JSONObject: result)!
            if !response.responseStat.status {
                Utility.showValidationError("Error", message: response.responseStat.msg, viewController: vc)
            }
            else {
                Utility.showValidationError("Success", message: response.responseStat.msg, viewController: vc)
                let responseDict = result as! NSDictionary
                onCompletion(responseDict)
            }
        }
        
    }
    
    class func submitProductReview(_ product_id: Int, note: String, rating: String, user_id: Int, showLoader: Bool, vc: UIViewController,view: UIView?, onCompletion: @escaping (_ response: AnyObject?) -> Void) {
        HttpClient.postRequest("api/customer/review/add", param:["shop_id":Constants.shopId as AnyObject, "product_id": product_id as AnyObject, "note": note as AnyObject, "rating": rating as AnyObject, "user_id": user_id as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
            print(result!)
            let response: Response1 = Mapper<Response1>().map(JSONObject: result)!
            if !response.responseStat.status {
                Utility.showValidationError("Error", message: response.responseStat.msg, viewController: vc)
            }
            else {
                let responseDict = result as! NSDictionary
                onCompletion(responseDict)
            }
        }
        
    }
    
    class func logout(_ showLoader: Bool, vc: UIViewController, onCompletion: @escaping (_ response: NSDictionary) -> Void) {
        HttpClient.getRequest("logout", param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: vc.view) { (result: AnyObject) in
            print(result)
            let response: Response1 = Mapper<Response1>().map(JSONObject: result)!
            if !response.responseStat.status {
                Utility.showValidationError("Error", message: response.responseStat.msg, viewController: vc)
            }
            else {
                let responseDict = result as! NSDictionary
                onCompletion(responseDict)
            }
        }
    }
    
    class func getBanners(_ showLoader: Bool, view: UIView?, onCompletion: @escaping (_ response: NSArray) -> Void) {
        HttpClient.getRequest("api/banner/all", param:["shop_id":Constants.shopId as AnyObject], showLoader: showLoader, view: nil) { (result: AnyObject) in
            let response: Response1 = Mapper<Response1>().map(JSONObject: result)!
            if !response.responseStat.status {
                
            }
            else {
//                let responseDict = result as! NSDictionary
                let images = result["responseData"]!
                onCompletion(images! as! NSArray)
            }
        }
    }
    
    class func getManufacturers(offset: Int, limit: Int,showLoader: Bool, vc: UIViewController,view: UIView?, onCompletion: @escaping (_ response: [Manufacturer]) -> Void) {
        HttpClient.postRequest("api/manufacturer/all", param:["shop_id":Constants.shopId as AnyObject, "offset": offset as AnyObject, "limit": limit as AnyObject], showLoader: showLoader, view: view) { (result: AnyObject?) in
            print(result!)
            let response: ManufacturerResponse = Mapper<ManufacturerResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Data Received" {
                    onCompletion([])
                }
            }
            else {
                onCompletion(response.responseData)
            }
        }
    }
    
    class func getProductsByBrand(_ manufacturer_id: Int, offset: Int, limit: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ products: [Product]) -> Void) {
        HttpClient.postRequest("api/product/manufacturer/all",param:["shop_id":Constants.shopId as AnyObject,"manufacture_id": manufacturer_id as AnyObject, "offset" :offset as AnyObject,"limit":limit as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            print(result!)
            let response: ProductResponse = Mapper<ProductResponse>().map(JSONObject: result)!
            if !response.responseStat.status {
                if response.responseStat.msg == "No Data Received" {
                    onCompletion([])
                }
            }
            else{
                let products: [Product] = response.responseData!
                onCompletion(products)
            }
        }
    }
    
    class func cancelOrder(_ orderId: Int, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ response: AnyObject) -> Void) {
        HttpClient.postRequest("api/paymentcancel",param:["shop_id":Constants.shopId as AnyObject,"order_id": orderId as AnyObject], showLoader: showLoader, view: view){ (response: AnyObject?) in
            print(response!)
            let response: Response1 = Mapper<Response1>().map(JSONObject: response)!
            if !response.responseStat.status {
                print("Error")
            }
            else {
                onCompletion(response)
            }
        }
    }
    
    class func orderSuccess(_ orderId: Int, payment_details: String, showLoader: Bool,view: UIView?, onCompletion: @escaping (_ response: AnyObject) -> Void) {
        HttpClient.postRequest("api/paymentsuccess",param:["shop_id":Constants.shopId as AnyObject,"order_id": orderId as AnyObject, "payment_details": payment_details as AnyObject], showLoader: showLoader, view: view){ (response: AnyObject?) in
            print(response!)
            let response: Response1 = Mapper<Response1>().map(JSONObject: response)!
            if !response.responseStat.status {
                print("Error")
            }
            else {
                onCompletion(response)
            }
        }
    }
    
    class func loginWithAccessKey(token: String!, showLoader: Bool, view: UIView, onCompletion: @escaping (_ response: UserInfo) -> Void) {
        HttpClient.postRequest("api/login/accesstoken",param:["shop_id":Constants.shopId as AnyObject,"accesstoken": token as AnyObject], showLoader: showLoader, view: view) { (response: AnyObject?) in
            let response: UserResponse = Mapper<UserResponse>().map(JSONObject: response)!
            if !response.responseStat.status {
                Utility.clearUser()
            }
            else {
                onCompletion(response.responseData!)
            }
        }
    }
    
    class func loginWithAccessKey2(token: String!, showLoader: Bool, view: UIView, onCompletion: @escaping (_ loginResponse: LoginResponse) -> Void) {
        HttpClient.postRequest("api/login/accesstoken",param:["shop_id":Constants.shopId as AnyObject,"accesstoken": token as AnyObject], showLoader: showLoader, view: view) { (response: AnyObject?) in
            let loginResponse: LoginResponse = Mapper<LoginResponse>().map(JSONObject: response)!
            onCompletion(loginResponse)
        }
    }
    
    class func applyVoucherCode(_ voucherCode: String, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ discount: VoucherDiscount) -> Void) {
        HttpClient.postRequest("api/checkout/voucher",param:["shop_id":Constants.shopId as AnyObject,"voucher_code": voucherCode as AnyObject], showLoader: showLoader, view: view) { (response: AnyObject?) in
            print(response!)
            let response: VoucherResponse = Mapper<VoucherResponse>().map(JSONObject: response)!
            if !response.responseStat.status {
                view?.makeToast(message: response.responseStat.msg)
            }
            else {
                onCompletion(response.responseData!)
            }
        }
    }
    
    class func removeProductFromWishlist(_ product_id: Int, vc: UIViewController, showLoader: Bool, view: UIView?, onCompletion: @escaping (_ success: Bool) -> Void) {
        HttpClient.postRequest("api/wishlist/remove",param:["shop_id":Constants.shopId as AnyObject,"product_id": product_id as AnyObject], showLoader: showLoader, view: view){ (result: AnyObject?) in
            print(result!)
            let response: Response1 = Mapper<Response1>().map(JSONObject: result)!
            if !response.responseStat.status {
                onCompletion(false)
                vc.view.makeToast(message: response.responseStat.msg!)
            }
            else {
                onCompletion(true)
            }
        }
    }
    
    class func login2(_ email: String, password: String, onCompletion: @escaping (_ response: NSDictionary) -> Void) {
        HttpClient.postRequest("login",param:["email" :email as AnyObject,"password":password as AnyObject], showLoader: false, view: nil){ (result: AnyObject?) in
            onCompletion(result as! NSDictionary)
        }
    }
    
    
    
}
