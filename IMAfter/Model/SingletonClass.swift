//
//  SingletonClass.swift
//  IMAfter
//
//  Created by SIERRA on 11/29/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class SingletonClass: NSObject {
    
    //    MARK: Variable for the app...
    
    var user_id = ""
    var get_all_post = NSMutableArray()
    var all_post_Count = String()
    var get_category_ids = NSArray()
    var getall_postCategories = NSArray()
    var offerTosell = NSDictionary()
    var post_wanted = NSDictionary()
    var saved_post = NSDictionary()
    var update_account = NSArray()
    var get_account = NSArray()
    var saved_post_details = NSDictionary()
    var wanted_post_details = NSDictionary()
    var deleteOffer = NSDictionary()
    var close_Post = NSDictionary()
    var search_post = NSArray()
    var ChatData :PostData!
    var CurrentChatUser = String()
    // MARK: Singleton Object Creation
    static let sharedInstance: SingletonClass = {
        let singletonObject = SingletonClass()
        return singletonObject
    }()
    
    // MARK: Initializer
    override init() {
        // initial value set to some random value
    }
    
    //Variables for user default valur of user id
    //    var user_Id = UserDefaults.standard.string(forKey: "user_id")
    
    //Variables for all services api
}
