//
//  ViewController.swift
//  I’M After
//
//  Created by MAC on 11/6/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookLogin

class ViewController: UIViewController {

    var dictFb:NSDictionary!
    var logintype = String()
    var fb_id = String()
    var fb_type = String()
    var fb_email = String()
    var fb_firstname = String()
    var fb_lastname = String()
    var fb_gender = String()
    var fb_userimage:String!
    var fb_userName = String()
    
//    @IBOutlet var createAccountlogoView: UIView!
//    @IBOutlet var createAccountView: UIView!
    @IBOutlet var fbView: UIView!
    @IBOutlet var loginLogoView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var fbLogoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        RoundView(view: createAccountlogoView)
//        RoundView(view: createAccountView)
        RoundView(view: fbView)
        RoundView(view: loginLogoView)
        RoundView(view: loginView)
        RoundView(view: fbLogoView)

    }

    @IBAction func btnLogin(_ sender: UIButton) {
        PresentTab()
    }
    
    func sague()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: FACBOOK BUTTON...
    @IBAction func btnFBLogin(_ sender: UIButton)
    {
  
        //Start @[@"public_profile", @"email", @"user_friends"]
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile","user_birthday"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if (result?.isCancelled)! {
                    
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
            else
            {
                print(error as Any )
            }        }
        
        //End
    }
    
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name,gender, picture.type(large), email,age_range,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    //                    name,email,gender,fb_id,image(optional),phone
                    
                    self.dictFb = (result as! NSDictionary)
                    print(self.dictFb)
                    self.logintype = "F"
                    self.fb_id = self.dictFb.value(forKey: "id") as! String
                    self.fb_email = self.dictFb.value(forKey: "email") as! String
                    self.fb_firstname = self.dictFb.value(forKey: "first_name") as! String
                    self.fb_lastname = self.dictFb.value(forKey: "last_name") as! String
                    self.fb_gender = self.dictFb.value(forKey: "gender") as! String
                    self.fb_userimage = self.dictFb.value(forKeyPath: "picture.data.url") as! String
                    
                    let name1 = self.fb_firstname
                    let name2 = self.fb_lastname
                    let Name = name1 + " " + name2
                    print(Name)
                    self.fb_userName = Name
                    self.facebooklogin()
                    
                    
                }
            })
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                // self.stopAnimating()
                Utilities.ShowAlertView(title: "Message", message: "Not successfully Login ", viewController: self)
            }
            
        }
    }
    
    //MARK:FACEBOOK_LOGIN_API
    func facebooklogin() {
        self.showProgress()
        let params = ["user_name": self.fb_userName,
                      "email": self.fb_email,
                      "unique_id_F": self.fb_id,
                       ]
        
        WebService.webService.facebook_loginApi(params: params as NSDictionary){ _ in
            self.hideProgress()
            self.sague()
            
        }
    }

    
    @IBAction func createAcntBtnAct(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func PresentTab()
    {
      let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

