//
//  TabbarViewController.swift
//  I’M After
//
//  Created by MAC on 11/6/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        self.tabBar.items![3].badgeValue = nil
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("RefreshList"), object: nil)
    }

    @objc func refresh(_notification:Notification) {
        
        let receivedInfo = _notification.object as! NSDictionary
        print("receivedInfo \(receivedInfo)")
        let totalMessageCount = "\(receivedInfo.value(forKey: "msg_count") ?? "0")"
        
        if totalMessageCount != "0" {
            
            self.tabBar.items![3].badgeValue = totalMessageCount
            
        }else{
            
            self.tabBar.items![3].badgeValue = nil
        }
        UIApplication.shared.applicationIconBadgeNumber = Int(totalMessageCount)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        
//        
//        print(tabBarController.selectedIndex)
//        
//        if tabBarController.selectedIndex == 0 {
//            if let naVController = storyboard?.instantiateViewController(withIdentifier: "NavViewController") as? NavViewController {
//                tabBarController.viewControllers![0] = naVController
//          }
//            
//        }
//        
//    }


}
