//
//  SavedViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/18/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var openSaved_Post = NSMutableArray()
    var closeSaved_Post = NSMutableArray()
    var postId = NSMutableArray()
    var postStatus = NSMutableArray()
    var postImage = NSMutableArray()
    var postPrice = NSMutableArray()
    var postTitle = NSMutableArray()
    var postCategory_id = NSMutableArray()
    var categoryName = NSMutableArray()
    var postTime = NSMutableArray()
    var unanswered_Msg = NSMutableArray()
    var offerId = NSMutableArray()
    var offerId1 = NSMutableArray()
    var offerImage = NSMutableArray()
    var offerPrice = NSMutableArray()
    var friendId = NSMutableArray()
    var friendName = NSMutableArray()
    var friendImage = NSMutableArray()
    var friendMsg = NSMutableArray()
    var cell = SavedTableViewCell()
    
    @IBOutlet weak var saved_table: UITableView!
    
    
   
    var sectionTitle = ["Open", "Closed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tabBarController?.tabBar.isHidden = false
        self.showProgress()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        self.savedpost_Details_Api()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - BUTTON ACTIONS
    
    
    @IBAction func btnUnAnswered(_ sender: UIButton) {
        
     tabBarController?.selectedIndex = 3
    
    }
    
    @IBAction func deleteBtn_Act(_ sender: SectionButton)
    {
//        self.deleteOffer_Api()
        if  sender.section == 0 {
        if let DetailDic = openSaved_Post[sender.tag] as? NSDictionary {
            
            print(DetailDic)
            
               self.showProgress()

                markFav(postID: "\(DetailDic.value(forKey: "post_id") ?? "")", favStatus: "N")
                
                self.saved_Post_Api(status: "N", postID: "\(DetailDic.value(forKey: "post_id") ?? "")")
    
        }
        }else{
            if let DetailDic = closeSaved_Post[sender.tag] as? NSDictionary {
                
                print(DetailDic)
                
                self.showProgress()
                
                markFav(postID: "\(DetailDic.value(forKey: "post_id") ?? "")", favStatus: "N")
                
                self.saved_Post_Api(status: "N", postID: "\(DetailDic.value(forKey: "post_id") ?? "")")
                
            }
            
        }
    }
    
    @IBAction func viewMsgsBtn_Act(_ sender: SectionButton) {
        print(sender.tag)
        if let DetailDic = sender.section == 0 ? openSaved_Post[sender.tag] as? NSDictionary : closeSaved_Post[sender.tag] as? NSDictionary {
            let strName = "\(DetailDic.value(forKey: "post_title") ?? "")"
            let strPostName = "\(DetailDic.value(forKey: "post_title") ?? "")"
            let strFriendPic = "\(DetailDic.value(forKey: "post_image") ?? "")"
            let strPostID = "\(DetailDic.value(forKey: "post_id") ?? "")"
            let strFriendID = "\(DetailDic.value(forKey: "friend_id") ?? "")"
            let strCount = "\(DetailDic.value(forKey: "unreadmsg_count") ?? "0")"
//          let strFriendID = "\(((DetailDic.value(forKey: "offer") as! NSArray)[0] as AnyObject).value(forKey: "friend_id") ?? "")"
            SingletonClass.sharedInstance.ChatData = PostData(Name: strName, PostName: strPostName, Time: "", LastMessage: "", friendPic: strFriendPic, PostID: strPostID, friendID: strFriendID, messageCount: strCount)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func tableSelectBtn_Act(_ sender: SectionButton) {
        
        print(sender.tag)
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let data = sender.section == 0 ? self.openSaved_Post[sender.tag] as! NSDictionary : self.closeSaved_Post[sender.tag] as! NSDictionary
        vc.selectedPostArr = data
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func offerToSellBtn_Act(_ sender: SectionButton) {
        
        print((sender as AnyObject).tag)
        let selectedPostId = sender.section == 0 ? (openSaved_Post[sender.tag] as AnyObject).value(forKey: "post_id") : (closeSaved_Post[sender.tag] as AnyObject).value(forKey: "post_id")
       //print(selectedPostId)
        let vc = storyboard?.instantiateViewController(withIdentifier: "OfferSellViewController") as! OfferSellViewController
        vc.selected_postId = "\(selectedPostId ?? "")"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: - TABLEVIEW DELEGATES
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat 
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        headerView.backgroundColor = UIColor.white
        
        let lbl1 = UILabel()
        lbl1.frame = CGRect(x: headerView.frame.origin.x + 22, y: headerView.frame.origin.y+10, width: headerView.frame.size.width - 44, height: headerView.frame.size.height-10)
        lbl1.backgroundColor = UIColor.clear
        lbl1.text = sectionTitle[section]
        lbl1.textColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1)
        lbl1.font = lbl1.font.withSize(26)
        headerView.addSubview(lbl1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       if section == 0
       {
        return openSaved_Post.count
        }
        else
       {
        return closeSaved_Post.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            
            if ((openSaved_Post[indexPath.row] as AnyObject).value(forKey:"offer") as! NSArray).count != 0 {
       
                return 310
            }
            else
            {
                return 175
            }
            
            
        }
        else if indexPath.section == 1
        {
            if ((closeSaved_Post[indexPath.row] as AnyObject).value(forKey:"offer") as! NSArray).count != 0 {
                
                return 310
            }
            else
            {
                return 175
            }
            
        }
    
            return 0
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         cell = saved_table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedTableViewCell
        //        cell.tableSelectBtn.tag = indexPath.row
        
        cell.saved_collection.tagSection = indexPath.section
        
        if indexPath.section == 0
        {
            cell.btnDeletePost.tag = indexPath.row
            cell.btnDeletePost.section = indexPath.section
            
            cell.viewMsgsBtn.tag = indexPath.row
            cell.viewMsgsBtn.section = indexPath.section
            cell.tableSelectBtn.tag = indexPath.row
            cell.tableSelectBtn.section = indexPath.section
            cell.offerToCellBtn_out.tag = indexPath.row
            cell.offerToCellBtn_out.section = indexPath.section
            
            self.postId = (openSaved_Post.value(forKey: "post_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.postCategory_id = (openSaved_Post.value(forKey: "post_category_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.postStatus = (openSaved_Post.value(forKey: "post_status") as! NSArray).mutableCopy() as!NSMutableArray
            self.postImage = (openSaved_Post.value(forKey: "post_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.postPrice = (openSaved_Post.value(forKey: "post_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.postTitle = (openSaved_Post.value(forKey: "post_title") as! NSArray).mutableCopy() as!NSMutableArray
            self.categoryName = (openSaved_Post.value(forKey: "category_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.postTime = (openSaved_Post.value(forKey: "post_time") as! NSArray).mutableCopy() as!NSMutableArray
            self.unanswered_Msg = (openSaved_Post.value(forKey: "unanswered_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
            let url : NSString = self.postImage.object(at: indexPath.row) as! NSString
            let searchURL : NSURL = NSURL(string: url as String)!
            
            cell.tablePost_Img.sd_setImage(with:searchURL as URL! , placeholderImage: #imageLiteral(resourceName: "placeholderImg"))
            
            cell.category_Nam.text = (self.categoryName.object(at: indexPath.row) as! String)
            cell.post_Nam.text = (self.postTitle.object(at: indexPath.row) as! String)
            cell.unanswered_Msg.text = String(describing: self.unanswered_Msg.object(at: indexPath.row) as! NSNumber) + " " + "unanswered messages"
            
            cell.tablePost_price.text = (self.postPrice.object(at: indexPath.row) as! String)

            let Date1 = (self.postTime.object(at: indexPath.row) as! String)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
            let date = dateFormatter.date(from: Date1) //according to date format your date string
            print(date ?? "")
            
            cell.tablePostImg_Day.text = timeAgoDisplay(date: date!)
            
            if self.offerId.count != 0
            {
//                cell.collectionBackView_ht.constant = 0
                cell.collectionBackView.isHidden = false
                cell.offerToSellView.isHidden = true
                cell.viewMsgsBtn.isHidden = false
                
            }
            else
            {
                cell.collectionBackView_ht.constant = 0
                cell.collectionBackView.isHidden = true
                cell.offerToSellView.isHidden = false
                cell.viewMsgsBtn.isHidden = true
            }
            
            if ((openSaved_Post[indexPath.row] as AnyObject).value(forKey:"offer") as! NSArray).count == 0 {
                
                cell.collectionBackView_ht.constant = 0;
                cell.offerToSellView.isHidden = false

            }else{
                
                cell.collectionBackView_ht.constant = 136;

            }
        }
        else if indexPath.section == 1
        {
            cell.btnDeletePost.section = indexPath.section
            cell.btnDeletePost.tag = indexPath.row
            
            cell.viewMsgsBtn.tag = indexPath.row
            cell.viewMsgsBtn.section = indexPath.section
            cell.tableSelectBtn.tag = indexPath.row
            cell.tableSelectBtn.section = indexPath.section
            cell.offerToCellBtn_out.tag = indexPath.row
            cell.offerToCellBtn_out.section = indexPath.section
            
            self.postId = (closeSaved_Post.value(forKey: "post_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.postCategory_id = (closeSaved_Post.value(forKey: "post_category_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.postStatus = (closeSaved_Post.value(forKey: "post_status") as! NSArray).mutableCopy() as!NSMutableArray
            self.postImage = (closeSaved_Post.value(forKey: "post_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.postPrice = (closeSaved_Post.value(forKey: "post_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.postTitle = (closeSaved_Post.value(forKey: "post_title") as! NSArray).mutableCopy() as!NSMutableArray
            self.categoryName = (closeSaved_Post.value(forKey: "category_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.postTime = (closeSaved_Post.value(forKey: "post_time") as! NSArray).mutableCopy() as!NSMutableArray
            self.unanswered_Msg = (closeSaved_Post.value(forKey: "unanswered_msg") as! NSArray).mutableCopy() as!NSMutableArray
            let url : NSString = self.postImage.object(at: indexPath.row) as! NSString
            let searchURL : NSURL = NSURL(string: url as String)!
            cell.tablePost_Img.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
            cell.category_Nam.text = (self.categoryName.object(at: indexPath.row) as! String)
            cell.post_Nam.text = (self.postTitle.object(at: indexPath.row) as! String)
            cell.unanswered_Msg.text = String(describing: self.unanswered_Msg.object(at: indexPath.row) as! NSNumber) + " " + "unanswered messages"
            
            cell.tablePost_price.text = (self.postPrice.object(at: indexPath.row) as! String)
            cell.tablePostImg_Day.text = (self.postTime.object(at: indexPath.row) as! String)
            
            if self.offerId1.count != 0
            {
                //cell.collectionBackView_ht.constant = 0
                cell.collectionBackView.isHidden = false
                cell.offerToSellView.isHidden = true
                cell.viewMsgsBtn.isHidden = false
              
            }
            else
            {
                cell.collectionBackView_ht.constant = 0
                cell.collectionBackView.isHidden = true
                cell.offerToSellView.isHidden = false
                cell.viewMsgsBtn.isHidden = true
                
            }
            
            if ((closeSaved_Post[indexPath.row] as AnyObject).value(forKey:"offer") as! NSArray).count == 0 {
                
                cell.collectionBackView_ht.constant = 0;
                cell.offerToSellView.isHidden = false
                cell.offerToSellView.isHidden = true
            }else{
                
                cell.collectionBackView_ht.constant = 136;

            }
            
        }
        
        
        
//        if indexPath.row == 1 || indexPath.row == 2
//        {
//            cell.collectionBackView_ht.constant = 0
//            cell.collectionBackView.isHidden = true
//            cell.offerToSellView.isHidden = false
//            cell.viewMsgsBtn.isHidden = true
//        }
//        else
//        {
//            cell.collectionBackView_ht.constant = 135
//            cell.collectionBackView.isHidden = false
//            cell.offerToSellView.isHidden = true
//            cell.viewMsgsBtn.isHidden = false
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //        guard let tableViewCell = cell as? TableViewCell else { return }
        let cell = cell as! SavedTableViewCell
        cell.setCollection(dataSourceDelegate: self, forRow: indexPath.row)
        
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        for  cells  in saved_table.visibleCells {
            
            let cell = cells as! SavedTableViewCell
            
            cell.saved_collection.reloadData()
            
        }
        
    }
    
    
    //MARK: Change Date to Time ago
    
    func timeAgoDisplay(date:Date) -> String {
        let secondsAgo = Int(Date().timeIntervalSince(date))
        
        if secondsAgo < 60 {
            return "\(secondsAgo) seconds ago"
        }
            
        else if secondsAgo < 60 * 60 {
            return "\(secondsAgo / 60) minutes ago"
        }
            
        else if secondsAgo < 60 * 60 * 24 {
            return "\(secondsAgo / 60 / 60) hours ago"
        }
        else if secondsAgo < 60 * 60 * 24 * 7 {
            return "\(secondsAgo / 60 / 60 / 24 ) days ago"
        }
        return "\(secondsAgo / 60 / 60 / 24 / 7) weeks ago"
    }

    
    //MARK: SAVED_POST_DETAILS_API
    
    func savedpost_Details_Api() {
        
        let params = ["user_id": UserDefaults.standard.value(forKey: "user_id")
            
        ]
        
        WebService.webService.savedPost_DetailsApi(vc: self, params: params as NSDictionary){ _ in
            
            print(SingletonClass.sharedInstance.saved_post_details)
            print("Saved Post Details Api Updated Successfully")
            
            self.openSaved_Post = (SingletonClass.sharedInstance.saved_post_details.value(forKey: "open") as! NSArray).mutableCopy() as! NSMutableArray
        
            self.openSaved_Post =  NSMutableArray(array: self.openSaved_Post.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray

            self.offerId = (self.openSaved_Post.value(forKeyPath: "offer.offer_id") as! NSArray).mutableCopy() as!NSMutableArray
            
            self.closeSaved_Post = (SingletonClass.sharedInstance.saved_post_details.value(forKey: "close") as! NSArray).mutableCopy() as! NSMutableArray
            self.offerId1 = (self.closeSaved_Post.value(forKeyPath: "offer.offer_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.sectionTitle = ["Open", "Closed"]
            self.saved_table.reloadData()
            self.hideProgress()
        }
    }
   
    //MARK: Delete Offer_API
    func deleteOffer_Api()
    {
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }
        else
        {
            let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as? String as Any,
                          "offer_id": "4",
                
            ]
            WebService.webService.deleteOffer_Api(vc: self, params: params as NSDictionary){ _ in
                
                let alert = UIAlertController(title: "Message", message: "Post Deleted Successfully", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action -> Void in
                  
                    print("action are work....")
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
}

extension SavedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        let myCollectionView = collectionView as! SectionCollectionView
        
        if myCollectionView.tagSection == 0{
        return (offerId[collectionView.tag] as AnyObject).count
        }
        else
       {
        return (offerId1[collectionView.tag] as AnyObject).count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! SavedCollectionViewCell
        
        let myCollectionView = collectionView as! SectionCollectionView
        
        if myCollectionView.tagSection == 0{
          
            self.offerImage = (openSaved_Post.value(forKeyPath: "offer.offer_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.offerPrice = (openSaved_Post.value(forKeyPath: "offer.offer_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendId = (openSaved_Post.value(forKeyPath: "offer.friend_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendName = (openSaved_Post.value(forKeyPath: "offer.friend_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendImage = (openSaved_Post.value(forKeyPath: "offer.friend_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendMsg = (openSaved_Post.value(forKeyPath: "offer.friend_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
            
            let url : NSString = (self.offerImage[collectionView.tag] as AnyObject).object(at: indexPath.row) as! NSString
            let searchURL : NSURL = NSURL(string: url as String)!
            
            collCell.collectionPost_Img.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
            
            let url1 : NSString = (self.friendImage[collectionView.tag] as AnyObject).object(at: indexPath.row) as! NSString
            let searchURL1 : NSURL = NSURL(string: url1 as String)!
            
            print(searchURL1)
            
            collCell.collectionUser_Img.sd_setImage(with:searchURL1 as URL! , placeholderImage: nil)
            collCell.collectionPost_price.text = ((self.offerPrice[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
            collCell.collectionUser_Nam.text = ((self.friendName[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
            collCell.collectionTextview_text.text = ((self.friendMsg[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
        
        }
        else if myCollectionView.tagSection == 1
        {
           // self.offerId = (closeSaved_Post.value(forKeyPath: "offer.offer_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.offerImage = (closeSaved_Post.value(forKeyPath: "offer.offer_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.offerPrice = (closeSaved_Post.value(forKeyPath: "offer.offer_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendId = (closeSaved_Post.value(forKeyPath: "offer.friend_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendName = (closeSaved_Post.value(forKeyPath: "offer.friend_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendImage = (closeSaved_Post.value(forKeyPath: "offer.friend_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendMsg = (closeSaved_Post.value(forKeyPath: "offer.friend_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
            let url : NSString = (self.offerImage[collectionView.tag] as AnyObject).object(at: indexPath.row) as! NSString
            let searchURL : NSURL = NSURL(string: url as String)!
            print(searchURL)
            
            collCell.collectionPost_Img.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
            
         //   let url1 : NSString = (self.friendImage[0] as AnyObject).object(at: indexPath.row) as! NSString
            let searchURL1 : NSURL = NSURL(string: url as String)!
            
            collCell.collectionUser_Img.sd_setImage(with:searchURL1 as URL! , placeholderImage: #imageLiteral(resourceName: "placeholderImg"))
            collCell.collectionPost_price.text = ((self.offerPrice[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
            collCell.collectionUser_Nam.text = ((self.friendName[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
            collCell.collectionTextview_text.text = ((self.friendMsg[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
        }
        
        return collCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     //   let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
      //  navigationController?.pushViewController(vc, animated: true)
        
        let myCollectionView = collectionView as! SectionCollectionView
        
        if let DetailDic = myCollectionView.tagSection == 0 ? openSaved_Post[collectionView.tag] as? NSDictionary : closeSaved_Post[collectionView.tag] as? NSDictionary {
            let strName = "\(DetailDic.value(forKey: "post_title") ?? "")"
            let strPostName = "\(DetailDic.value(forKey: "post_title") ?? "")"
            let strFriendPic = "\(DetailDic.value(forKey: "post_image") ?? "")"
            let strPostID = "\(DetailDic.value(forKey: "post_id") ?? "")"
            let strFriendID = "\(DetailDic.value(forKey: "friend_id") ?? "")"
            let strCount = "\(DetailDic.value(forKey: "unreadmsg_count") ?? "0")"
            //  let strFriendID = "\(((DetailDic.value(forKey: "offer") as! NSArray)[0] as AnyObject).value(forKey: "friend_id") ?? "")"
            SingletonClass.sharedInstance.ChatData = PostData(Name: strName, PostName: strPostName, Time: "", LastMessage: "", friendPic: strFriendPic, PostID: strPostID, friendID: strFriendID, messageCount: strCount)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    //MARK: saved_Post_API(for saving image from home scrren through star button)
    func saved_Post_Api(status:String,postID:String) {
        
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }else
        {
            
            let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as? String,
                          "post_id": postID,
                          "status":status
            ]
            WebService.webService.saved_post_Api(vc: self, params: params as NSDictionary){ _ in
                print("Offer has been saved...")
                self.savedpost_Details_Api()
                
                NotificationCenter.default.post(name:UPDATE_MY_HOMESCREEN , object: nil, userInfo:nil)
            }
        }
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
    
}

class SavedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var collectionPost_Img: UIImageView!
    
    @IBOutlet var collectionPost_price: UILabel!
    
    @IBOutlet var collectionUser_Img: DesignableImage!
    
    @IBOutlet var collectionUser_Nam: UILabel!
    
    @IBOutlet var collectionMsg_View: UIView!
    
    @IBOutlet var collectionMsg_text: UILabel!
    
    @IBOutlet weak var collectionTextview_text: UITextView!
    

}



