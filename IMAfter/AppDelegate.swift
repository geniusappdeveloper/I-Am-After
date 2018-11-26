 //
//  AppDelegate.swift
//  IMAfter
//
//  Created by SIERRA on 11/17/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.initKeyboard()
        
        let center = UNUserNotificationCenter.current()
    
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
            
            switch setttings.soundSetting{
            case .enabled:
                
                print("enabled sound setting")
                
            case .disabled:
                
                print("setting has been disabled")
                
            case .notSupported:
                print("something vital went wrong here")
            }
        }
        
        //MARK: use for facebook integration
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Override point for customization after application launch.

        return true
    }
    
    func initKeyboard() {
        IQKeyboardManager.sharedManager().enable = true  //For Keyboard
    }
    
    //MARK: for device token...
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0...deviceToken.count-1
        {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
        print("DEVICE TOKEN = \(deviceToken)")
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        UserDefaults.standard.set(token, forKey: "DEVICETOKEN");
        UserDefaults.standard.synchronize();
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        UserDefaults.standard.set("C79674A99B442F237A072D7B3944BDD630A234063336A4F686556F49A271AD0B", forKey: "DEVICETOKEN");
        UserDefaults.standard.synchronize();
        
        print("i am not available in simulator \(error)")
        
    }
    
    //MARK: for facebook integration...
    
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    if(url.scheme!.isEqual("fb1961051694145431"))
    {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    else
    {
        return true
    }
    
    }
    //MARK:======================= NotificationCenter Delegates ========================
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
     
        
        print(response.notification.request.content.userInfo["aps"] as Any)
        
        if let ChatData = response.notification.request.content.userInfo["aps"] as? NSDictionary {
            let story = UIStoryboard.init(name: "Main", bundle: nil)

          print(ChatData)
        let rootVC = self.window?.rootViewController
     //   print(self.window?.rootViewController?.classForCoder)
        if let tabBarController = rootVC?.childViewControllers.last as? UITabBarController?  {
            
            
            
          //  tabBarController?.selectedIndex = 3
            let CurrentVC = tabBarController?.selectedViewController
            
          //  print(CurrentVC?.classForCoder)

            let vc = story.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController

            SingletonClass.sharedInstance.ChatData = PostData(Name: "\(ChatData.value(forKeyPath: "alert.post_title") ?? "NA")", PostName: "\(ChatData.value(forKeyPath: "alert.post_title") ?? "NA")", Time: "\(ChatData.value(forKeyPath: "alert.msg_time") ?? "NA")", LastMessage: "", friendPic: "\(ChatData.value(forKeyPath: "alert.friend_image") ?? "NA")", PostID: "\(ChatData.value(forKeyPath: "alert.post_id") ?? "NA")", friendID: "\(ChatData.value(forKeyPath: "alert.friend_id") ?? "NA")", messageCount: "0")
            CurrentVC?.navigationController?.pushViewController(vc, animated: true)
            
            //CurrentVC?.alert(title: "Data", message: "\(ChatData)")
            
            return
            
        }
            
            let CurrentVC = NSStringFromClass((self.window?.rootViewController?.childViewControllers.last?.classForCoder)!)

            if (CurrentVC == "IMAfter.ChatViewController"){
            
                SingletonClass.sharedInstance.CurrentChatUser = ""
              self.window?.rootViewController?.childViewControllers.last?.navigationController?.popViewController(animated: false)
              let vc = story.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                SingletonClass.sharedInstance.ChatData = PostData(Name: "\(ChatData.value(forKeyPath: "alert.post_title") ?? "NA")", PostName: "\(ChatData.value(forKeyPath: "alert.post_title") ?? "NA")", Time: "\(ChatData.value(forKeyPath: "alert.msg_time") ?? "NA")", LastMessage: "", friendPic: "\(ChatData.value(forKeyPath: "alert.friend_image") ?? "NA")", PostID: "\(ChatData.value(forKeyPath: "alert.post_id") ?? "NA")", friendID: "\(ChatData.value(forKeyPath: "alert.friend_id") ?? "NA")", messageCount: "0")
                self.window?.rootViewController?.childViewControllers.last?.navigationController?.pushViewController(vc, animated: false)
                return
            }
            
            let vc = story.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            SingletonClass.sharedInstance.ChatData = PostData(Name: "\(ChatData.value(forKeyPath: "alert.post_title") ?? "NA")", PostName: "\(ChatData.value(forKeyPath: "alert.post_title") ?? "NA")", Time: "\(ChatData.value(forKeyPath: "alert.msg_time") ?? "NA")", LastMessage: "", friendPic: "\(ChatData.value(forKeyPath: "alert.friend_image") ?? "NA")", PostID: "\(ChatData.value(forKeyPath: "alert.post_id") ?? "NA")", friendID: "\(ChatData.value(forKeyPath: "alert.friend_id") ?? "NA")", messageCount: "0")
            self.window?.rootViewController?.childViewControllers.last?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

    //This is key callback to present notification while the app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        Device_Token_Api()
     
        let rootVC = self.window?.rootViewController
        if let tabBarController = rootVC?.childViewControllers.last as? UITabBarController?  {
            
            let CurrentVC = tabBarController?.selectedViewController
            
            if (CurrentVC?.isKind(of: MyWantedsViewController.self))!{
                
            NotificationCenter.default.post(name:UPDATE_MY_WANTEDSCREEN , object: nil, userInfo:nil)

                
            }
            if (CurrentVC?.isKind(of: MessageListViewController.self))!{
                
                NotificationCenter.default.post(name:UPDATE_MY_MESSAGESCREEN , object: nil, userInfo:nil)
                
                
            }

        }
        
        if let ChatData = notification.request.content.userInfo["aps"] as? NSDictionary {

            if SingletonClass.sharedInstance.CurrentChatUser == "\(ChatData.value(forKeyPath: "alert.friend_id") ?? "NA")"{
                
//                if let VC = rootVC?.childViewControllers.last {
//
//                    VC.alert(title: "Got Notification", message: "\(notification.request.content.userInfo)")
//
//                }
                
                NotificationCenter.default.post(name:MESSAGECOME , object: nil, userInfo:notification.request.content.userInfo)
            }else{
                completionHandler( [.alert,.sound,.badge])
            }
        }else{
        completionHandler( [.alert,.sound,.badge])
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
            WebService.webService.device_token_Api(vc: HomeViewController().self, params: params as NSDictionary){ _ in
                
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        Device_Token_Api()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "IMAfter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


