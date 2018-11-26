//
//  Utilities.swift
//  Food Ordering
//
//  Created by SIERRA on 12/08/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit
import Foundation
import MMDrawerController
import NVActivityIndicatorView
import GoogleMaps
import GooglePlaces


class Utilities: NSObject,NVActivityIndicatorViewable,CLLocationManagerDelegate {
    
    
    
//    //MARK: LeftSideMenu Button...
//    class func LeftSideMenu() {
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.centerContainer.toggle(MMDrawerSide.left, animated: true, completion: nil)
//    }
//   //MARK: AttachSideMenuController...
//    class func AttachSideMenuController(){
//        let mainstoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let leftViewController = mainstoryBoard.instantiateViewController(withIdentifier: "Side_menuController") as! Side_menuController
//        let leftsidenav = UINavigationController(rootViewController: leftViewController)
//        let appdeg:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        appdeg.centerContainer.leftDrawerViewController = leftsidenav
//   }
//  //MARK: HideLeftSideMenu...
//    class func HideLeftSideMenu(){
//       let appdeg:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        appdeg.centerContainer.leftDrawerViewController = nil
//
//    }
//    MARK: ShowAlertView...
    class func ShowAlertView(title: String, message: String, viewController: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }

    class func ShowAlertView2(title: String, message: String, viewController: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // add the actions (buttons)
//        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
       viewController.present(alert, animated: true, completion: nil)
    
    }

    }


