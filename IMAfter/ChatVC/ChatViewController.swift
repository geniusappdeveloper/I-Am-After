//
//  ChatViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/24/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

   
class ChatViewController: UIViewController {

    @IBOutlet var userImg: UIImageView!
    @IBOutlet var chatImg: UIImageView!
    @IBOutlet var chatView1: UIView!
    @IBOutlet var chatView2: UIView!
    @IBOutlet var chatView3: UIView!
    @IBOutlet var chatView4: UIView!
    @IBOutlet var chatView5: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var navbar_Outlet: UIButton!
    @IBOutlet var lblNavTitle: UILabel!
    
    
    var PostData :PostData!
    var isFromOfferSellVC = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navbar_Outlet.isHidden = true

        if let check = SingletonClass.sharedInstance.ChatData {
        
         userImg.setImage(url: check.friendPic)
         lblName.text = check.Name
         lblTitle.text = check.PostName
         lblNavTitle.text = check.PostName
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        RoundView(view: userImg)
        RoundSpecificCorners(view: chatImg)
        RoundSpecificCorners(view: chatView1)
        RoundSpecificCorners(view: chatView2)
        RoundLeftCorners(view: chatView3)
        RoundLeftCorners(view: chatView4)
        RoundSpecificCorners(view: chatView5)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - BUTTON ACTIONS
    @IBAction func backBtnAct(_ sender: Any)
    {
//      navigationController?.popViewController(animated: true)
        
      //  let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
       // self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        
      //  navigationController?.popToRootViewController(animated: false)
        SingletonClass.sharedInstance.CurrentChatUser = ""
        
        if isFromOfferSellVC {
          
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[0], animated: false);
            }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    

}
