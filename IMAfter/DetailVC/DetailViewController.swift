//
//  DetailViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/21/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit
import SDWebImage
import GSImageViewerController

class DetailViewController: UIViewController {
    
    var selectedPostArr = NSDictionary()
    var image = UIImage()
    var pushString : String = ""
    var isFav :Bool = false
    
    @IBOutlet weak var navTitle_out: UILabel!
    @IBOutlet weak var postDisplayImage_out: UIImageView!
    @IBOutlet weak var postImg_out: UIImageView!
    
    @IBOutlet weak var userImg_out: DesignableImage!
    
    @IBOutlet weak var userNam_out: UILabel!
    
    @IBOutlet weak var postPrice_out: UILabel!
    
    @IBOutlet weak var postTitle_Desc: UITextView!
    
    @IBOutlet weak var postTitle_out: UILabel!
    
    @IBOutlet weak var image_vw_out: UIView!
    @IBOutlet weak var navRight_Btn_Out: UIButton!
    
    @IBOutlet weak var starBtn_out: DesignableButton!
    
    @IBOutlet weak var offertoSell_vw_out: DesignableView!
    
    @IBOutlet weak var navleftBtn_out: UIButton!
    
    
    @IBOutlet var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.image_vw_out.isHidden = true
        // Do any additional setup after loading the view.
//        if self.pushString == "1"{
//            self.mainView.isHidden = false
//        }
//        else{
//            self.mainView.isHidden = true
//        }
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
          print(self.selectedPostArr)
        
        tabBarController?.tabBar.isHidden = true
        
        if self.selectedPostArr.count != 0
        {
        self.navTitle_out.text = (self.selectedPostArr.value(forKey: "post_title") as! NSString) as String!
        
        let url : NSString = self.selectedPostArr.value(forKey: "post_image") as! NSString
        let searchURL : NSURL = NSURL(string: url as String)!
        self.postImg_out.sd_setImage(with: searchURL as URL!, placeholderImage: nil)
        self.postTitle_out.text = (self.selectedPostArr.value(forKey: "post_title") as! NSString) as String!
        self.postPrice_out.text = self.selectedPostArr.value(forKey: "post_price") as! NSString as String
        self.postTitle_Desc.text = self.selectedPostArr.value(forKey: "post_description") as! NSString as String
        self.userNam_out.text = "\(self.selectedPostArr.value(forKey: "user_name") ?? self.selectedPostArr.value(forKey: "friend_name") ?? "")"
            let url1  = "\(self.selectedPostArr.value(forKey: "profile_pic") ?? self.selectedPostArr.value(forKey: "friend_image") ?? "")"
        let searchURL1 : NSURL = NSURL(string: url1 as String)!
        self.userImg_out.sd_setImage(with: searchURL1 as URL!, placeholderImage: nil)
                        
        let favStatus = "\(self.selectedPostArr.value(forKey: "fav_status") ?? "")"
            
            if favStatus == "N"{
             
                isFav = false
                starBtn_out.backgroundColor = GREY_COLOR

                
            }else{
                
                
              isFav = true
              starBtn_out.backgroundColor = THEME_COLOR
                
            }
            
            if "\(selectedPostArr.value(forKey: "user_id") ?? "\(selectedPostArr.value(forKey: "post_by") ?? "\(selectedPostArr.value(forKey: "friend_id") ?? "")")")" == "\(UserDefaults.standard.value(forKey: "user_id") ?? "N")" {
                
                self.offertoSell_vw_out.isHidden = true
                self.starBtn_out.isHidden = true
                self.mainView.isHidden = true


            
            }else{
                self.offertoSell_vw_out.isHidden = false
                self.starBtn_out.isHidden = false
                self.mainView.isHidden = false


            }
        }
        else
        {

        }
    }
    // MARK: - BUTTON ACTIONS
    
    @IBAction func offerToSell_Act(_ sender: Any) {
        
//        if "\(selectedPostArr.value(forKey: "post_by") ?? "")" == "\(UserDefaults.standard.value(forKey: "user_id") ?? "N")" {
//         
//            return
//        }
        
        if self.selectedPostArr.count != 0
        {
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "OfferSellViewController") as! OfferSellViewController
        
        let selectedPostId = "\(self.selectedPostArr.value(forKey: "post_id") ?? "")"
        print(selectedPostId as Any)
        vc.selected_postId = selectedPostId
        navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            
        }
    }
    
    
    @IBAction func fashionImg_Btn(_ sender: Any)
    {
        
//        self.starBtn_out.isHidden = true
//        self.offertoSell_vw_out.isHidden = true
//        self.image_vw_out.isHidden = false
//        self.navRight_Btn_Out.isHidden = true
//        if self.selectedPostArr.count != 0 {
//        let url : NSString = self.selectedPostArr.value(forKey: "post_image") as! NSString
//        let searchURL : NSURL = NSURL(string: url as String)!
//        self.postDisplayImage_out.sd_setImage(with: searchURL as URL!, placeholderImage: nil)
//        }
//        else{
//
//        }
        
        if let image = postImg_out.image {
            
            let imageInfo      = GSImageInfo(image: image, imageMode: .aspectFit, imageHD: nil)
            let transitionInfo = GSTransitionInfo(fromView: self.view)
            let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            present(imageViewer, animated: true, completion: nil)
            
        }
    }
    
     @IBAction func naviRight_Clicked(_ sender: Any)
    {
        if "\(selectedPostArr.value(forKey: "post_by") ?? "")" == "\(UserDefaults.standard.value(forKey: "user_id") ?? "N")" {
            
        myPostActionSheet()
        }else{
            
        ReportActionSheet()
        }
    }
    
    func swipeleftNav_btn()
    {
       
    }
    
     @IBAction func naviLeft_Clicked(_ sender: Any)
    {
        
        
        if image_vw_out.isHidden == true
        {
            
         navigationController?.popViewController(animated: true)
        }
        else
        {
            image_vw_out.isHidden = true
            self.starBtn_out.isHidden = false
            self.offertoSell_vw_out.isHidden = false
            self.navRight_Btn_Out.isHidden = false
        }
    }
    
    
  
    
    func myPostActionSheet(){
        
   let actionSheet = UIAlertController(title: "Please Select", message: nil, preferredStyle: .actionSheet)
        
        let btnDeletePost = UIAlertAction(title: "Delete", style: .destructive) { (deleteAction) in
         self.deletePost()
        }
        let btnOpenPost = UIAlertAction(title: "Open", style: .default) { (deleteAction) in
       
            self.OpenCloseApi(type: "1")
        }
        let btnClosePost = UIAlertAction(title: "Close", style: .default) { (deleteAction) in
            self.OpenCloseApi(type: "2")

        }
        
        actionSheet.addAction(btnDeletePost)
        actionSheet.addAction(btnOpenPost)
        actionSheet.addAction(btnClosePost)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func ReportActionSheet(){
        
        let actionSheet = UIAlertController(title: "Please Select", message: nil, preferredStyle: .actionSheet)
        
        let btnDeletePost = UIAlertAction(title: "Report as inappropriate", style: .destructive) { (deleteAction) in
            
        }

        
        actionSheet.addAction(btnDeletePost)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: Delete Post Api
    
    func deletePost(){
     
        showProgress()
        let parms = [
            "user_id":"\(UserDefaults.standard.value(forKey: "user_id") ?? "N")",
            "post_id":"\(selectedPostArr.value(forKey: "post_id") ?? "")"
        
        ]
      
        webservicesPostRequest(baseString: API_BASE_URL + DELETE_POST, parameters: parms, success: { (response) in
            
            self.hideProgress()
            print(response)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            self.alert(title: "Error!!", message: error.localizedDescription)
        }
    }
    
    @IBAction func btnMarkFav(_ sender: Any) {
      
        if isFav {
            
          starBtn_out.backgroundColor = GREY_COLOR
          isFav = false
          saved_Post_Api(status: "N")
          markFav(postID: "\(self.selectedPostArr.value(forKey: "post_id") ?? "")", favStatus: "N")
            
        }else{
            
            starBtn_out.backgroundColor = THEME_COLOR
            isFav = true
            saved_Post_Api(status: "Y")
            markFav(postID: "\(self.selectedPostArr.value(forKey: "post_id") ?? "")", favStatus: "Y")

        }
        
        
    }
    
    //MARK: saved_Post_API(for saving image from home scrren through star button)
    func saved_Post_Api(status:String) {
        
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }else
        {
            
            let params = ["user_id":"\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                          "post_id": "\(self.selectedPostArr.value(forKey: "post_id") ?? "")",
                          "status":status
            ]
            WebService.webService.saved_post_Api(vc: self, params: params as NSDictionary){ _ in
                print("Offer has been saved...")
                
                
            }
        }
    }
    
    
    
    func OpenCloseApi(type:String){
    
        
        showProgress()
        let parms = [
            "user_id":"\(UserDefaults.standard.value(forKey: "user_id") ?? "N")",
            "post_id":"\(selectedPostArr.value(forKey: "post_id") ?? "")",
            "status":type
        ]
        webservicesPostRequest(baseString: API_BASE_URL + Close_Post, parameters: parms, success: { (response) in
            print(response)
            self.hideProgress()
            
            self.alert(title: "Alert", message: "\(response.value(forKey: "message") ?? "Un Known Error occur please try again later")")
            
        }) { (error) in
            self.alert(title: "Error!!", message: error.localizedDescription)
        }
        
    }
    
    
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
    
}
