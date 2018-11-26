//
//  HomeViewController.swift
//  I’M After
//
//  Created by MAC on 11/6/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import SDWebImage

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,CLLocationManagerDelegate,UISearchControllerDelegate,SendDataBack {

    
    
    var addressString : String = ""
    var pushString : String = ""
    var lat = Float()
    var longi = Float()
    var locationManager = CLLocationManager()
    var category_id = NSMutableArray()
    var user_id = NSMutableArray()
    var post_id = NSMutableArray()
    var post_image = NSMutableArray()
    var category_name = NSMutableArray()
    var post_title = NSMutableArray()
    var post_price = NSMutableArray()
    var selectedPostArr = NSDictionary()
    var scroll_Selected = String()
    var category_Name = NSMutableArray()
    var selectedCat_Arr = [String]()
    var main_selectedCat_Arr = String()
    var saved_Img = NSMutableArray()
    var starimage =  [UIImage]()
    var selectedImg = NSMutableArray()
    var cell = HomeVCCell()
    var selected_PostId = String()
    var search_text:String!
    var isSearchActive: Bool = false
    var check_filterCount: Bool = false
    
    var isFiltersOn = false

    // MARK: - OUTLETS
    
    var txtSearch = UITextField()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var navView_out: UIView!
    
   // @IBOutlet var txtSearch: UITextField!
    @IBOutlet var collectionViewList: UICollectionView!
    @IBOutlet var filterTable: UITableView!
    @IBOutlet var hiddenView: UIView!
    @IBOutlet var filterBackView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewHeight_out: NSLayoutConstraint!
    @IBOutlet weak var searchHeight_out: NSLayoutConstraint!
    
    // MARK: - VARIABLES
  
    
    // MARK: - INIT VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self, name: UPDATE_MY_HOMESCREEN, object: nil)
        //New observer added
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateData), name: UPDATE_MY_HOMESCREEN, object: nil)
        
        self.initSearchBar()
        self.hideFilters()
        self.pushString = "1"
        
        self.selectedCat_Arr = [String]()

    }
    
    @objc func UpdateData(){
        
        //self.collectionViewList.reloadData()
        self.getAllPostCategory_Api()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
      UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
    }
    
    
    
     override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: USER CUURENT LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        print(center)
        
        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        //        marker.map = self.MapView_out
        lat = Float(Double(userLocation!.coordinate.latitude))
        longi = Float(Double(userLocation!.coordinate.longitude))
        //        self.UpdateLoc_Api()
        
        locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        
        
        let latitude: String = NSString(format: "%.2f",lat) as String
        let longtude: String = NSString(format: "%.2f",longi) as String
        
        lat = Float(Double(userLocation!.coordinate.latitude))
        longi = Float(Double(userLocation!.coordinate.longitude))
        
        self.getAddressFromLatLong(latitude: lat, longitude: longi)
        
        
        if latitude != ""  || longtude != ""
        {
            if isSearchActive || isFiltersOn{
                
                
            }else{
                
                self.UpdateLoc_Api()
                self.Device_Token_Api()
                self.getAllPost_Api()
                self.getCategoryIds_Api()
                locationManager.stopUpdatingLocation()
            }

        }else
        {
            print("lat long not found")
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func getAddressFromLatLong(latitude:Float, longitude:Float)  {
        
        let ceo: CLGeocoder = CLGeocoder()
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        center.latitude = CLLocationDegrees(latitude)
        center.longitude = CLLocationDegrees(longitude)
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if let pm = placemarks{
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country as Any)
                    print(pm.locality as Any)
                    print(pm.subLocality as Any)
                    print(pm.thoroughfare as Any)
                    print(pm.postalCode as Any)
                    print(pm.subThoroughfare as Any)
                    print(pm.isoCountryCode as Any)

                }
                }
        })
        
    }
    
    //MARK: ...Search Bar Delegate...
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
     //   self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        return true
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        isSearchActive = true
        searchBar.endEditing(true)
        self.searchPost_Api()


    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        searchBar_out.tintColor = UIColor.white
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        searchBar.endEditing(true)
    
        searchBar.text = ""
        

        
      //  self.getAllPostCategory_Api()
        
        if isFiltersOn {
            
            self.getAllPostCategory_Api()

        }else{
            
        self.getAllPost_Api()
        
        }
//        if searchBar.text == nil || searchBar.text == ""
//        {
//
//        }
//        else
//        {
//        self.getAllPost_Api()
//        }

    }
    
    //MARK: SEARCH POST API
    func searchPost_Api() {
        self.pushString = "2"
        self.showProgress()
           let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as! String,
                          "latitude": lat,
                          "longitude": longi,
                          "title": txtSearch.text!
                          ] as [String : Any]
            WebService.webService.searchPost_Api(vc: self, params: params as NSDictionary){ _ in
               
                print(SingletonClass.sharedInstance.get_all_post)
                
                self.post_id = (SingletonClass.sharedInstance.get_all_post.value(forKey: "post_id") as! NSArray).mutableCopy() as! NSMutableArray
                self.saved_Img = (SingletonClass.sharedInstance.get_all_post.value(forKey: "Saved_status") as! NSArray).mutableCopy() as! NSMutableArray
                self.selectedImg = NSMutableArray()
                for i in 0..<self.saved_Img.count
                {
                    if self.saved_Img.object(at: i) as! String == "Y"
                    {
                        self.selectedImg.insert("1", at: i)
                    }
                    else
                    {
                        self.selectedImg.insert("0", at: i)
                    }
                }
                if self.post_id.count == 0 {
                self.alert(title: "Alert", message: "No data found.")
                }
                self.collectionViewList.reloadData()
            }
        }
    

    //MARK:UPDATE USER LAT & LONG API
    func UpdateLoc_Api() {
        
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("userid is nil")
        }else
        {
            
            let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as! String,
                          "latitude": lat,
                          "longitude": longi,
                          ] as [String : Any]
            WebService.webService.UpdateLoc_Api(vc: self, params: params as NSDictionary){ _ in
                //            Utilities.ShowAlertView(title: "Alert", message: "Login Api Successfull", viewController: self)
                
            }
        }
    }
    
    //MARK: Device_Token_API
    func Device_Token_Api() {
        
        var localTimeZoneName: String { return TimeZone.current.identifier }

        
        if UserDefaults.standard.value(forKey: "DEVICETOKEN") as? String == nil
        {
            print("devicetoken is nil")
        }else
        {
            
            let params = ["user_id": "\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                          "device_id": "\(UserDefaults.standard.value(forKey: "DEVICETOKEN") ?? "")",
                          "device_type": "I",
                          "timezone" :localTimeZoneName
                          ]
            WebService.webService.device_token_Api(vc: self, params: params as NSDictionary){ _ in
                
            }
        }
    }
    
    //MARK: saved_Post_API(for saving image from home scrren through star button)
    func saved_Post_Api(status:String) {
        
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }else
        {
            
            let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as? String,
                          "post_id": self.selected_PostId,
                          "status":status
                         ]
            WebService.webService.saved_post_Api(vc: self, params: params as NSDictionary){ _ in
                print("Offer has been saved...")
                
                
            }
        }
    }

    //MARK: GetAllPost_API
    func getAllPost_Api(){
         self.pushString = "1"
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
                print("user_id is nil")
        }
        else
        {
            let params = [
                "user_id": UserDefaults.standard.value(forKey: "user_id") as? String as Any,
                "latitude": lat,
                "longitude": longi
            ]
            WebService.webService.getAllPost_Api(vc: self, params: params as NSDictionary){ _ in
                print(SingletonClass.sharedInstance.get_all_post)
                
            self.post_id = (SingletonClass.sharedInstance.get_all_post.value(forKey: "post_id") as! NSArray).mutableCopy() as! NSMutableArray
            self.saved_Img = (SingletonClass.sharedInstance.get_all_post.value(forKey: "Saved_status") as! NSArray).mutableCopy() as! NSMutableArray
                
                self.selectedImg = NSMutableArray()
                for i in 0..<self.saved_Img.count
                {
                    if "\(self.saved_Img.object(at: i) )" == "Y"
                    {
                        self.selectedImg.insert("1", at: i)
                    }
                    else
                    {
                        self.selectedImg.insert("0", at: i)
                    }
                }
                self.collectionViewList.reloadData()
                
             }
        }
    }
    
    //MARK: GET_CATEGORY_IDS_API
    func getCategoryIds_Api()
    {
        
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("userid is nil")
        }
        else
        {
            let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as! String,
                       ] as [String : Any]
            WebService.webService.getcategoryid_Api(vc: self, params: params  as NSDictionary){ _ in
               print(SingletonClass.sharedInstance.get_category_ids)
                self.category_id = (SingletonClass.sharedInstance.get_category_ids.value(forKey: "id") as! NSArray).mutableCopy() as! NSMutableArray
                
                self.category_Name = (SingletonClass.sharedInstance.get_category_ids.value(forKey: "category_name") as! NSArray).mutableCopy() as! NSMutableArray
                
                self.category_Name.insert("All Categories", at: 0)
                self.filterTable.reloadData()
                
            }
        }
    }
    
    //MARK: Get_All_Post_Categorys_API
    func getAllPostCategory_Api() {
        
        print(main_selectedCat_Arr)
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }
        else
        {
            let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as? String as Any,
                          "category_id": self.main_selectedCat_Arr,
            ]
            
            print(self.selectedCat_Arr.count)
            check_filterCount = true
            
            if self.selectedCat_Arr.count == 0
            {
                check_filterCount = false
                isFiltersOn = false
                self.getAllPost_Api()
            }
           else
            {
            WebService.webService.getall_postCategories_Api(vc: self, params: params as NSDictionary){ _ in
                print(SingletonClass.sharedInstance.getall_postCategories)
         
            SingletonClass.sharedInstance.get_all_post = NSMutableArray()
                
                SingletonClass.sharedInstance.get_all_post = (SingletonClass.sharedInstance.getall_postCategories).mutableCopy() as! NSMutableArray
         self.post_id = (SingletonClass.sharedInstance.get_all_post.value(forKey: "post_id") as! NSArray).mutableCopy() as! NSMutableArray
            
                
        SingletonClass.sharedInstance.get_all_post = NSMutableArray(array:SingletonClass.sharedInstance.get_all_post.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
         self.collectionViewList.reloadData()
                
            }
            }
        }
    }
    
    //MARK:
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
     //   tabBarController?.tabBar.isHidden = true
    }
    //MARK: Get_All_Post_Categorys_API
    func markFav(postID:String,favStatus:String) {
        
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }
        else
        {
            let params :[String : String] = ["user_id": "\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                          "post_id": postID,
                          "is_fav":favStatus
                          ]
        
            self.webservicesPostRequest(baseString: API_BASE_URL + ADD_FAV, parameters: params , success: { (response) in
                print(response)
                
            }, failure: { (error) in
                
                self.alert(title: "Error!!", message: error.localizedDescription)
                
            })

    }

    }

    // MARK: - INIT METHODS
    func initSearchBar() {
        self.navigationItem.title = "Explore"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        let navigationbar = self.navigationController?.navigationBar
        searchController.searchBar.delegate = self
        
        
//        elf.definesPresentationContext = true
//
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.definesPresentationContext = true
        
        navigationbar?.barTintColor = THEME_COLOR
        navigationItem.searchController = searchController
       
        searchController.searchBar.setImage(#imageLiteral(resourceName: "search"), for: .search, state: .normal)

        
        txtSearch = searchController.searchBar.value(forKey: "_searchField") as! UITextField
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]

        //  txtSearch.backgroundColor = UIColor(red:0, green:163/255, blue:171/255, alpha:1)
        let backgroundview: UIView? = txtSearch.subviews.first

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        backgroundview?.backgroundColor = .white
        backgroundview?.alpha = 0.1
        backgroundview?.layer.cornerRadius = 10
        backgroundview?.clipsToBounds = true
        
       if let glassIconView = (searchController.searchBar.value(forKey: "_searchField") as! UITextField).leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
        }
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white], for: .normal)
        

        
    }
    
    
    func hideFilters() {
        self.hiddenView.isHidden = true
        self.filterBackView.isHidden = true
    }
    
    func showFilters() {
    //    self.hiddenView.isHidden = false
     //   self.filterBackView.isHidden = false
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController {
         vc.delegate = self
         vc.SelectedArray = self.selectedCat_Arr
         present(vc, animated: true, completion: nil)
            
        }


    }
    
    // MARK: - COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        let resuableView : UICollectionReusableView? = nil
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderViewCell
            
           headerView.backgroundColor = UIColor.white
           headerView.postCount_out.text = "\(SingletonClass.sharedInstance.get_all_post.count)"
            if selectedCat_Arr.count != 0 {
                headerView.lblFilterCount.text = "Filter :\(selectedCat_Arr.count)"
                headerView.lblFilterCount.backgroundColor = THEME_COLOR
                headerView.lblFilterCount.textColor  = .white
                
            }else{
                
                headerView.lblFilterCount.text = "Filter"
                headerView.lblFilterCount.backgroundColor = .white
                headerView.lblFilterCount.textColor  = UIColor.init(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0)
            }
            if check_filterCount == true
            {
//            headerView.filtercat_Count.isHidden = false
//            headerView.filtercat_Count.text = String(self.selectedCat_Arr.count )
            }
            else
            {
//                headerView.filtercat_Count.isHidden = true
            }
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
            return resuableView!
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isSearchActive == true
        {
            
            if  self.post_id.count > 0
            {
                return self.post_id.count
            }
            else
            {
                return 0
            }
        }
        else
        {
        
        
        if  self.post_id.count > 0
            {
                return self.post_id.count
            }
            else
            {
                return 0
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
         cell  = collectionViewList.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeVCCell
        
        
        self.post_image = (SingletonClass.sharedInstance.get_all_post.value(forKey: "post_image") as! NSArray).mutableCopy() as! NSMutableArray
        self.category_name = (SingletonClass.sharedInstance.get_all_post.value(forKey: "categorys_name") as! NSArray).mutableCopy() as! NSMutableArray
        self.post_title = (SingletonClass.sharedInstance.get_all_post.value(forKey: "post_title") as! NSArray).mutableCopy() as! NSMutableArray
        self.post_price = (SingletonClass.sharedInstance.get_all_post.value(forKey: "post_price") as! NSArray).mutableCopy() as! NSMutableArray
        
//        let url : NSString = self.post_image.object(at: indexPath.row) as! NSString
//        let searchURL : NSURL = NSURL(string: url as String)!
//
//        cell.postImage_out.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
//
//        cell.catgoryNam_out.text = self.category_name.object(at: indexPath.row) as? String
//        cell.postName_out.text = self.post_title.object(at: indexPath.row) as? String
//        cell.priceRange_out.text = self.post_price.object(at: indexPath.row) as? String
//        cell.saveImgBtn_out.tag = indexPath.row
        

        let url : NSString = self.post_image.object(at:indexPath.row) as! NSString
        let searchURL : NSURL = NSURL(string: url as String)!
        
        cell.postImage_out.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
       
        cell.catgoryNam_out.text = self.category_name.object(at:indexPath.row) as? String
        cell.postName_out.text = self.post_title.object(at:indexPath.row) as? String
        cell.priceRange_out.text = self.post_price.object(at:indexPath.row) as? String
        cell.saveImgBtn_out.tag = indexPath.row
        
        //Manvir
        //13/3/18
        if let DetailDic = SingletonClass.sharedInstance.get_all_post[indexPath.row] as? NSDictionary {
            
            if "\(DetailDic.value(forKey: "fav_status") ?? "")" == "Y"{
                
                cell.starImg_out.image = #imageLiteral(resourceName: "solidGreenStar")

            }else{
                
                cell.starImg_out.image = #imageLiteral(resourceName: "star")

            }
            
            if "\(DetailDic.value(forKey: "fav_status") ?? "")" == "" {
                if "\(DetailDic.value(forKey: "Saved_status") ?? "")" == "Y"{
                    
                    cell.starImg_out.image = #imageLiteral(resourceName: "solidGreenStar")
                    
                }else{
                    
                    cell.starImg_out.image = #imageLiteral(resourceName: "star")
                    
                }
                
                
            }
            
            
        }
        
//        if self.selectedImg.object(at: indexPath.row) as! String == "1"
//        {
//            cell.starImg_out.image = #imageLiteral(resourceName: "solidGreenStar")
//        }
//        else
//        {
//             cell.starImg_out.image = #imageLiteral(resourceName: "star")
//
//        }
        
     return cell
    }
    
   
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
     return CGSize(width: collectionViewList.bounds.width / 2 - 5, height: 185)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        self.selectedPostArr = SingletonClass.sharedInstance.get_all_post[indexPath.row] as! NSDictionary
        vc.selectedPostArr = self.selectedPostArr
        vc.pushString = self.pushString
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.pushViewController(vc, animated: false)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
//    func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoinfgdfgt {
//        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
//        let horizontalOffset = proposedContentOffset.x
//        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: self.collectionViewList!.bounds.size)
//
//
//        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
//            let itemOffset = layoutAttributes.frame.origin.x
//            if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
//                offsetAdjustment = itemOffset - horizontalOffset
//            }
//        }
//        
//        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
//    }

    
    // MARK: - TABLEVIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.category_id != nil && self.category_id.count > 0
        {
            return self.category_id.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return 36
    }
    
    //MARK: FILTER TableView Cell...
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterTableViewCell = self.filterTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterTableViewCell
        

        cell.categoryName.text = (category_Name[indexPath.row] as! String)
           return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = self.filterTable.cellForRow(at: indexPath) as! FilterTableViewCell
        if cell.checkBoxImg.backgroundColor == UIColor(red: 43/255, green: 148/255, blue: 160/255, alpha: 1.0)
        {
            cell.checkBoxImg.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
            if indexPath.row == 0
            {
                
            }
            else
            {
                let selectedCat_Id:String = "\(self.category_id.object(at: indexPath.row - 1))"
            print(selectedCat_Id)
             for i in 0..<selectedCat_Arr.count
                {
                    if selectedCat_Id == selectedCat_Arr[i]
                    {
                      
                     let index =  selectedCat_Arr.index(of: selectedCat_Id)
                        selectedCat_Arr.remove(at: index!)
                        break;
                    }
                    else{
                        
                    }
                }
                
                print(selectedCat_Arr)
                
            }
        }
        else
        {
            cell.checkBoxImg.backgroundColor = UIColor(red: 43/255, green: 148/255, blue: 160/255, alpha: 1.0)
            if indexPath.row == 0
            {
             
            }
            else
            {
                let selectedCat_Id = String(describing: category_id.object(at: indexPath.row - 1))
                print(selectedCat_Id)
                
               
                    if selectedCat_Arr.contains(selectedCat_Id)
                    {
                    }
                    else
                    {
                      self.selectedCat_Arr.append(String(selectedCat_Id))
                    }
                
                
            }
            print(self.selectedCat_Arr)
            
        }
         print("Final selectedArr...",self.selectedCat_Arr)
        
       main_selectedCat_Arr = "[\(self.selectedCat_Arr.joined(separator:","))]"
             print(main_selectedCat_Arr)
    }
    
    // MARK: - TEXTFIELD METHOD
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchController.isActive = false
        searchPost_Api()
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - BUTTON ACTIONS
    @IBAction func filterBtnAct(_ sender: Any) {
        self.showFilters()
    }
    
    @IBAction func closeBtnAct(_ sender: Any) {
        self.hideFilters()
    }
    
    @IBAction func applyBtnAct(_ sender: Any)
    {
     self.hideFilters()
        self.getAllPostCategory_Api()
        
//        self.selectedCat_Arr = [String]()
    }
    
    @IBAction func savedImg_Clicked(_ sender: UIButton)
    {
        //Manvir
        if let DetailDic = SingletonClass.sharedInstance.get_all_post[sender.tag] as? NSDictionary {
            
            let NewDic :NSMutableDictionary = NSMutableDictionary(dictionary: DetailDic)
             if "\(NewDic.value(forKey: "fav_status") ?? "")" == "Y"{
            
            NewDic.removeObject(forKey: "fav_status")
                NewDic.setValue("N", forKey: "fav_status")
                markFav(postID: "\(DetailDic.value(forKey: "post_id") ?? "")", favStatus: "N")
                SingletonClass.sharedInstance.get_all_post[sender.tag] = NewDic
                self.selected_PostId = "\(DetailDic.value(forKey: "post_id") ?? "")"
                self.saved_Post_Api(status: "N")

            }else{
                NewDic.removeObject(forKey: "fav_status")
                NewDic.setValue("Y", forKey: "fav_status")
                markFav(postID: "\(DetailDic.value(forKey: "post_id") ?? "")", favStatus: "Y")
                self.selected_PostId = "\(DetailDic.value(forKey: "post_id") ?? "")"
                self.saved_Post_Api(status: "Y")
                SingletonClass.sharedInstance.get_all_post[sender.tag] = NewDic

            }
          
          //  self.saved_Post_Api(status: "Y")
            collectionViewList.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    
        }
        
        
//        print((sender as AnyObject).tag)
//        let tagValue: Int = sender.tag
//        print(tagValue)
//
//        self.selected_PostId = "\(self.post_id.object(at: tagValue))"
//        print(self.selected_PostId)
//
//         if self.selectedImg.object(at: tagValue) as! String == "0"
//        {
//            cell.starImg_out.image = #imageLiteral(resourceName: "solidGreenStar")
//            self.selectedImg.replaceObject(at: tagValue, with: "1")
//            self.collectionViewList.reloadData()
//        }
//        else
//        {
//            cell.starImg_out.image = #imageLiteral(resourceName: "star")
//            self.selectedImg.replaceObject(at: tagValue, with: "0")
//             self.collectionViewList.reloadData()
//            self.saved_Post_Api(status: <#String#>)
//        }
        
    }
    
    //MARK:---- Custom Delegate -----
    func arrayList(selectedArray: [String]) {
        
        self.selectedCat_Arr = selectedArray
        main_selectedCat_Arr = "[\(self.selectedCat_Arr.joined(separator:","))]"
        print(main_selectedCat_Arr)
        self.getAllPostCategory_Api()

        isFiltersOn = true
        
    }
    
  
    
}


class HomeVCCell: UICollectionViewCell
{
    @IBOutlet weak var postImage_out: UIImageView!
    @IBOutlet weak var catgoryNam_out: UILabel!
    @IBOutlet weak var postName_out: UILabel!
    @IBOutlet weak var priceRange_out: UILabel!
    @IBOutlet var saveImgBtn_out: UIButton!
    
    @IBOutlet var starImg_out: UIImageView!

}

class HeaderViewCell: UICollectionReusableView
{
       @IBOutlet var postCount_out: DesignableLable!
    
    @IBOutlet var lblFilterCount: DesignableLable!
    
}




