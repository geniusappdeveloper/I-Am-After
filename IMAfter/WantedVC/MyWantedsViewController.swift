//
//  MyWantedsViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/20/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class MyWantedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var opemWanted_Post = NSMutableArray()
    var closeWanted_Post = NSMutableArray()
    var postId = NSMutableArray()
    var postId1 = NSMutableArray()
    var postStatus = NSMutableArray()
    var postImage = NSMutableArray()
    var postPrice = NSMutableArray()
    var postTitle = NSMutableArray()
    var postCategory_Id = NSMutableArray()
    var postCategory_Nam = NSMutableArray()
    var postTime = NSMutableArray()
    var unanswered_Msgs = NSMutableArray()
    var total_msg = NSMutableArray()
    var newunRead_Msgs = NSMutableArray()
    var offerId = NSMutableArray()
    var offerId1 = NSMutableArray()
    var offerImage = NSMutableArray()
    var offerPrice = NSMutableArray()
    var friendId = NSMutableArray()
    var friendName = NSMutableArray()
    var friendImage = NSMutableArray()
    var friendMsgs = NSMutableArray()
    var cell = MyWantedsTableViewCell()
    var totalMsgs_open = NSMutableArray()
    var totalMsgs_close = NSMutableArray()
    var toatalopen_countsArry = NSMutableArray()
    var toatalclosed_countsArry = NSMutableArray()
    @IBOutlet weak var myWanted_table: UITableView!
    
    var sectionTitle = ["Open", "Closed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        self.showProgress()

        // Do any additional setup after loading the view.
    }

    
    func initView(){
        
        
        NotificationCenter.default.removeObserver(self, name: UPDATE_MY_WANTEDSCREEN, object: nil)
        //New observer added
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateData), name: UPDATE_MY_WANTEDSCREEN, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        self.wantedpost_Details_Api()

    }
    
    @objc func UpdateData(){
        
        self.wantedpost_Details_Api()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - BUTTON ACTIONS
    
    @IBAction func btnUnread(_ sender: UIButton) {
        
      self.tabBarController?.selectedIndex = 3
        
    }
    
    
    @IBAction func btnNew(_ sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 3

    }
    
    
    
    @IBAction func newWantedBtn_Act(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostWantedViewController") as! PostWantedViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tableSelectBtn_Act(_ sender: SectionButton) {
        print(self.opemWanted_Post)

        if sender.section == 0 {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.selectedPostArr = self.opemWanted_Post[sender.tag] as! NSDictionary
        navigationController?.pushViewController(vc, animated: true)
            
        }else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.selectedPostArr = self.closeWanted_Post[sender.tag] as! NSDictionary
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @IBAction func closePost_Btn(_ sender: SectionButton)
    {
        
        if sender.section == 0{
            print(opemWanted_Post[sender.tag])
            guard let detailDic :NSDictionary = opemWanted_Post[sender.tag] as? NSDictionary else{
                
                return
            }
            
            
        self.closePost_Api(detailDic: detailDic)
        }else{
            print(closeWanted_Post[sender.tag])
            guard let detailDic :NSDictionary = closeWanted_Post[sender.tag] as? NSDictionary else{
                
                return
            }
            
            
            self.closePost_Api(detailDic: detailDic)
            
        }
    }
    
    
  func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitle[section]
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        headerView.backgroundColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:1) //UIColor.white
        
        let lbl1 = UILabel()
        lbl1.frame = CGRect(x: headerView.frame.origin.x + 22, y: headerView.frame.origin.y+10, width: headerView.frame.size.width - 44, height: headerView.frame.size.height-10)
        lbl1.backgroundColor = UIColor.clear
        lbl1.text = sectionTitle[section]
        lbl1.textColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1)
        lbl1.font = lbl1.font.withSize(26)
        headerView.addSubview(lbl1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0
        {
          //  let str =  self.toatalopen_countsArry.object(at: indexPath.row) as! String
          
            let str = "\((offerId[indexPath.row] as AnyObject).count ?? 0)"
            if str != "0"
            {

                return 310
            }
            else
            {
                return 175
            }


        }
        else if indexPath.section == 1
        {
          //  let str = self.toatalclosed_countsArry.object(at: indexPath.row) as! String
            
            
            let str = "\((offerId1[indexPath.row] as AnyObject).count ?? 0)"

            if str != "0"
            {

                return 310
            }
            else
            {
                return 175
            }

        }
        
        return 0
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return opemWanted_Post.count
        }
        else
        {
            return closeWanted_Post.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        cell = myWanted_table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyWantedsTableViewCell
        
        cell.myWanted_collection.tagSection = indexPath.section
        
        if indexPath.section == 0
        {
            cell.btnCloseListing.tag = indexPath.row
            cell.btnCloseListing.section = indexPath.section
            cell.tableSelectBtn.tag = indexPath.row
            cell.tableSelectBtn.section = indexPath.section
            self.postStatus = (opemWanted_Post.value(forKey: "post_status") as! NSArray).mutableCopy() as!NSMutableArray
            self.postImage = (opemWanted_Post.value(forKey: "post_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.postPrice = (opemWanted_Post.value(forKey: "post_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.postTitle = (opemWanted_Post.value(forKey: "post_title") as! NSArray).mutableCopy() as!NSMutableArray
            self.postCategory_Id = (opemWanted_Post.value(forKey: "post_category_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.postCategory_Nam = (opemWanted_Post.value(forKey: "post_category_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.postTime = (opemWanted_Post.value(forKey: "post_time") as! NSArray).mutableCopy() as!NSMutableArray
            self.newunRead_Msgs = (opemWanted_Post.value(forKey: "unread_mmsg") as! NSArray).mutableCopy() as!NSMutableArray
            self.unanswered_Msgs = (opemWanted_Post.value(forKey: "unanswered_msg") as! NSArray).mutableCopy() as!NSMutableArray
            self.total_msg = (opemWanted_Post.value(forKey: "total_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
            
            let url : NSString = self.postImage.object(at: indexPath.row) as! NSString
            let searchURL : NSURL = NSURL(string: url as String)!
            cell.wantedPost_Img.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
            cell.wantedCat_Nam.text = (self.postCategory_Nam.object(at: indexPath.row) as! String)
            cell.wantedCatPost_Nam.text = (self.postTitle.object(at: indexPath.row) as! String)
            cell.wantedPost_Day.text = (self.postTime.object(at: indexPath.row) as! String)
            cell.wantedPost_Price.text = (self.postPrice.object(at: indexPath.row) as! String)
            cell.wantedNew_msgs.text = String(describing: self.newunRead_Msgs.object(at: indexPath.row) as! NSNumber) + " " + "new"
            cell.wantedUnanswered_msgs.text = String(describing: self.unanswered_Msgs.object(at: indexPath.row) as! NSNumber) + "/\(self.total_msg.object(at: indexPath.row) ?? "")" + " " + "unanswered"
            
            
            
          //  let str = String(describing: self.totalMsgs_open.object(at: indexPath.row) as! NSNumber)
            let str =  "\((offerId[indexPath.row] as AnyObject).count ?? 0)"
            if str == "0"
            {
                //                cell.collectionBackView_ht.constant = 0
                cell.collectionBackView_ht.constant = 0
                cell.collectionBackView.isHidden = true
                cell.closelistViewBtn_out.isHidden = true
               
            }
            else
            {
                cell.collectionBackView_ht.constant = 135
                cell.collectionBackView.isHidden = false
                cell.closelistViewBtn_out.isHidden = false
               
            }
            

        }
        else if indexPath.section == 1
        {
            print(self.closeWanted_Post)
            cell.tableSelectBtn.tag = indexPath.row
            cell.tableSelectBtn.section = indexPath.section
            
            cell.btnCloseListing.tag = indexPath.row
            cell.btnCloseListing.section = indexPath.section
            
            
            self.postStatus = (closeWanted_Post.value(forKey: "post_status") as! NSArray).mutableCopy() as!NSMutableArray
            self.postImage = (closeWanted_Post.value(forKey: "post_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.postPrice = (closeWanted_Post.value(forKey: "post_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.postTitle = (closeWanted_Post.value(forKey: "post_title") as! NSArray).mutableCopy() as!NSMutableArray
            self.postCategory_Id = (closeWanted_Post.value(forKey: "post_category_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.postCategory_Nam = (closeWanted_Post.value(forKey: "post_category_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.postTime = (closeWanted_Post.value(forKey: "post_time") as! NSArray).mutableCopy() as!NSMutableArray
           
            self.newunRead_Msgs = (closeWanted_Post.value(forKey: "unread_mmsg") as! NSArray).mutableCopy() as!NSMutableArray
            self.unanswered_Msgs = (closeWanted_Post.value(forKey: "unanswered_msg") as! NSArray).mutableCopy() as!NSMutableArray
            self.total_msg = (closeWanted_Post.value(forKey: "total_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
            let url : NSString = self.postImage.object(at: indexPath.row) as! NSString
            let searchURL : NSURL = NSURL(string: url as String)!
            cell.wantedPost_Img.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
            cell.wantedCat_Nam.text = (self.postCategory_Nam.object(at: indexPath.row) as! String)
            cell.wantedCatPost_Nam.text = (self.postTitle.object(at: indexPath.row) as! String)
            cell.wantedPost_Day.text = (self.postTime.object(at: indexPath.row) as! String)
            cell.wantedPost_Price.text = (self.postPrice.object(at: indexPath.row) as! String)
            cell.wantedNew_msgs.text = String(describing: self.newunRead_Msgs.object(at: indexPath.row) as! NSNumber) + " " + "new"
            cell.wantedUnanswered_msgs.text = String(describing: self.unanswered_Msgs.object(at: indexPath.row) as! NSNumber) + "/\(self.total_msg.object(at: indexPath.row) ?? "")" + " " + "unanswered"
            
           // let str = String(describing: self.totalMsgs_close.object(at: indexPath.row) as! NSNumber)
            let str =  "\((offerId1[indexPath.row] as AnyObject).count ?? 0)"

            if str == "0"
            {
                //cell.collectionBackView_ht.constant = 0
                cell.collectionBackView_ht.constant = 0
                cell.collectionBackView.isHidden = true
                cell.closelistViewBtn_out.isHidden = true
            }
            else
            {
                cell.collectionBackView_ht.constant = 135
                cell.collectionBackView.isHidden = false
                cell.closelistViewBtn_out.isHidden = false
            }
            cell.closelistViewBtn_out.isHidden = true
        }


        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //guard let tableViewCell = cell as? TableViewCell else { return }
        let cell = cell as! MyWantedsTableViewCell
        cell.setCollection(dataSourceDelegate: self, forRow: indexPath.row)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        for  cells  in myWanted_table.visibleCells {
            
       let cell = cells as! MyWantedsTableViewCell
         
            cell.myWanted_collection.reloadData()
         
            let visibleRect = CGRect(origin: cell.myWanted_collection.contentOffset, size: cell.myWanted_collection.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            let visibleIndexPath = cell.myWanted_collection.indexPathForItem(at: visiblePoint)
            
            guard let indexPath = visibleIndexPath else { return }
            print(indexPath.row)
            
            if indexPath.row != 0 {
            
            cell.myWanted_collection.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
            }
        }
        
    }
    
    //MARK: WANTED_POST_DETAILS_API
    
    func wantedpost_Details_Api() {
        
        let params = ["user_id": UserDefaults.standard.value(forKey: "user_id")
            
        ]

        
        WebService.webService.wantedPost_DetailsApi(vc: self, params: params as NSDictionary){ (response)in
            
            if !response {
                
                self.opemWanted_Post.removeAllObjects()
                self.closeWanted_Post.removeAllObjects()
                self.hideProgress()
                self.myWanted_table.reloadData()

                return
            }
            
            print(SingletonClass.sharedInstance.saved_post_details)
            
            print("Wanted Post Details Api Updated Successfully")
            
            self.opemWanted_Post = ((SingletonClass.sharedInstance.saved_post_details.value(forKey: "open") as! NSArray).mutableCopy() as! NSMutableArray)
            
            print(self.opemWanted_Post)
            
            self.opemWanted_Post =  NSMutableArray(array: self.opemWanted_Post.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray

            
            self.offerId = (self.opemWanted_Post.value(forKeyPath: "offer.offer_id") as! NSArray).mutableCopy() as!NSMutableArray
            print(self.offerId)

            self.totalMsgs_open = (self.opemWanted_Post.value(forKey: "total_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
             self.closeWanted_Post = (SingletonClass.sharedInstance.saved_post_details.value(forKey: "close") as! NSArray).mutableCopy() as! NSMutableArray
            
            self.offerId1 = (self.closeWanted_Post.value(forKeyPath: "offer.offer_id") as! NSArray).mutableCopy() as!NSMutableArray
            
            self.totalMsgs_close = (self.closeWanted_Post.value(forKey: "total_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
            self.postId = (self.opemWanted_Post.value(forKey: "post_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.postId1 = (self.closeWanted_Post.value(forKey: "post_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.sectionTitle = ["Open", "Closed"]
            
            self.toatalopen_countsArry = NSMutableArray()
            self.toatalclosed_countsArry = NSMutableArray()
            
            for i in 0..<self.totalMsgs_open.count
            {
                 self.toatalopen_countsArry.insert(String(describing: self.totalMsgs_open.object(at: i) as! NSNumber), at: i)
               
            }
            for i in 0..<self.totalMsgs_close.count
            {
                self.toatalclosed_countsArry.insert(String(describing: self.totalMsgs_close.object(at: i) as! NSNumber), at: i)
                
            }
             
             self.myWanted_table.reloadData()
          
            self.hideProgress()
        }
    }
    
    //MARK: Close_Post_API
    func closePost_Api(detailDic:NSDictionary)
    {
        

        showProgress()
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }
        else
        {
            let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as? String as Any,
                          "post_id": "\(detailDic.value(forKey: "post_id") ?? "")",
                           "status":"2"
                          ]
            WebService.webService.closePost_Api(vc: self, params: params as NSDictionary){ _ in
                self.hideProgress()
                let alert = UIAlertController(title: "Message", message: "Post Closed Successfully", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action -> Void in
                    
                    print("action are work....")
                   self.wantedpost_Details_Api()
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
}
    

extension MyWantedsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //    if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.size.width-30, height: collectionView.frame.size.height)
//        }else{
//            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let myCollectionView = collectionView as! SectionCollectionView
        
        if myCollectionView.tagSection == 0{
        return (offerId[collectionView.tag] as AnyObject).count
       }else
       {
        return (offerId1[collectionView.tag] as AnyObject).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! WantedCollectionViewCell
        
        let myCollectionView = collectionView as! SectionCollectionView
        
        if myCollectionView.tagSection == 0
        {
            self.offerImage = (opemWanted_Post.value(forKeyPath: "offer.offer_image") as! NSArray).mutableCopy() as!NSMutableArray
            print(self.offerImage)
            self.offerPrice = (opemWanted_Post.value(forKeyPath: "offer.offer_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendId = (opemWanted_Post.value(forKeyPath: "offer.friend_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendName = (opemWanted_Post.value(forKeyPath: "offer.friend_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendImage = (opemWanted_Post.value(forKeyPath: "offer.friend_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendMsgs = (opemWanted_Post.value(forKeyPath: "offer.friend_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
            
            collCell.collPost_Count.text = "\(indexPath.row + 1)" + "/" + "\((offerId[collectionView.tag] as? NSArray)?.count ?? 1)"
            
            //"\((offerId[collectionView.tag] as AnyObject).count)"
            
             if let url  = (self.offerImage[collectionView.tag] as AnyObject).object(at: indexPath.row) as? String{
            let searchURL : NSURL = NSURL(string: url as String)!
            
            collCell.collPost_Img.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
            let url1 : NSString = (self.friendImage[collectionView.tag] as AnyObject).object(at: indexPath.row) as! NSString
            let searchURL1 : NSURL = NSURL(string: url1 as String)!
                
            collCell.collUser_Img.sd_setImage(with:searchURL1 as URL! , placeholderImage: nil)
                
                if let priceArray = offerPrice[collectionView.tag] as? NSArray {
                 
                    let strPrice  = "\(priceArray[indexPath.row])"
                    
                    if strPrice.contains("£") {
                     
                        collCell.collPost_Price.text = strPrice
                    }else{
                        
                      collCell.collPost_Price.text = "£" + strPrice
                    }
                    
                }
                
            collCell.collUser_Nam.text = ((self.friendName[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
            collCell.collChatTextview_Msgs.text = ((self.friendMsgs[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
            }

        }
        else if myCollectionView.tagSection == 1
        {
            //self.offerId = (closeWanted_Post.value(forKeyPath: "offer.offer_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.offerImage = (closeWanted_Post.value(forKeyPath: "offer.offer_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.offerPrice = (closeWanted_Post.value(forKeyPath: "offer.offer_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendId = (closeWanted_Post.value(forKeyPath: "offer.friend_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendName = (closeWanted_Post.value(forKeyPath: "offer.friend_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendImage = (closeWanted_Post.value(forKeyPath: "offer.friend_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendMsgs = (closeWanted_Post.value(forKeyPath: "offer.friend_msg") as! NSArray).mutableCopy() as!NSMutableArray
            
            
//            if self.offerImage.count == 0{
//                
//                return collCell
//            }
            let url : NSString = (self.offerImage[collectionView.tag] as AnyObject).object(at: indexPath.row) as! NSString
            let searchURL : NSURL = NSURL(string: url as String)!
            
            collCell.collPost_Img.sd_setImage(with:searchURL as URL! , placeholderImage: nil)
            
            let url1 : NSString = (self.friendImage[collectionView.tag] as AnyObject).object(at: indexPath.row) as! NSString
            let searchURL1 : NSURL = NSURL(string: url1 as String)!
            
            collCell.collUser_Img.sd_setImage(with:searchURL1 as URL! , placeholderImage: nil)
            collCell.collPost_Price.text = ((self.offerPrice[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
            collCell.collUser_Nam.text = ((self.friendName[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
            collCell.collChatTextview_Msgs.text = ((self.friendMsgs[collectionView.tag] as AnyObject).object(at: indexPath.row) as! String)
        }
        
        return collCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        let myCollectionView = collectionView as! SectionCollectionView
        
        if myCollectionView.tagSection == 0{
            self.offerImage = (opemWanted_Post.value(forKeyPath: "offer.offer_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.offerPrice = (opemWanted_Post.value(forKeyPath: "offer.offer_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendId = (opemWanted_Post.value(forKeyPath: "offer.friend_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendName = (opemWanted_Post.value(forKeyPath: "offer.friend_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendImage = (opemWanted_Post.value(forKeyPath: "offer.friend_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendMsgs = (opemWanted_Post.value(forKeyPath: "offer.friend_msg") as! NSArray).mutableCopy() as!NSMutableArray
            let OfferID = (opemWanted_Post.value(forKeyPath: "offer.post_id") as! NSArray).mutableCopy() as!NSMutableArray

            let strName = "\((self.friendName[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            let strPostName = "\((self.friendName[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            let strFriendPic = "\((self.friendImage[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            let strPostID = "\((OfferID[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            let strFriendID = "\((self.friendId[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            
            SingletonClass.sharedInstance.ChatData = PostData(Name: strName, PostName: strPostName, Time: "", LastMessage: "", friendPic: strFriendPic, PostID: strPostID, friendID: strFriendID, messageCount: "0")
            
        } else {
            
            // print(opemWanted_Post[indexPath.row])
            // SingletonClass.sharedInstance.ChatData = OpenArray[indexPath.row]
            print(closeWanted_Post)
            self.offerImage = (closeWanted_Post.value(forKeyPath: "offer.offer_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.offerPrice = (closeWanted_Post.value(forKeyPath: "offer.offer_price") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendId = (closeWanted_Post.value(forKeyPath: "offer.friend_id") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendName = (closeWanted_Post.value(forKeyPath: "offer.friend_name") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendImage = (closeWanted_Post.value(forKeyPath: "offer.friend_image") as! NSArray).mutableCopy() as!NSMutableArray
            self.friendMsgs = (closeWanted_Post.value(forKeyPath: "offer.friend_msg") as! NSArray).mutableCopy() as!NSMutableArray
            let OfferID = (closeWanted_Post.value(forKeyPath: "offer.post_id") as! NSArray).mutableCopy() as!NSMutableArray

            let strName = "\((self.friendName[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            let strPostName = "\((self.friendName[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            let strFriendPic = "\((self.friendImage[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            let strPostID = "\((OfferID[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            let strFriendID = "\((self.friendId[collectionView.tag] as AnyObject).object(at: indexPath.row))"
            
            SingletonClass.sharedInstance.ChatData = PostData(Name: strName, PostName: strPostName, Time: "", LastMessage: "", friendPic: strFriendPic, PostID: strPostID, friendID: strFriendID, messageCount: "0")
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

class WantedCollectionViewCell: UICollectionViewCell
{

    @IBOutlet var collPost_Img: UIImageView!
     @IBOutlet var collPost_New: DesignableLable!
     @IBOutlet var collPost_Price: UILabel!
     @IBOutlet var collPost_Count: UILabel!
     @IBOutlet var collUser_Img: DesignableImage!
    @IBOutlet var collUser_Nam: UILabel!
    
    @IBOutlet var collView_Msgtext: UIView!
    
    @IBOutlet var collChat_Msgs: UILabel!
    
    @IBOutlet weak var collChatTextview_Msgs: UITextView!
}


