//
//  LoginViewController.swift
//  I’M After
//
//  Created by SIERRA on 11/16/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var emailReqView: UIView!
    @IBOutlet var passwordReqView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var loginBtnView: UIView!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet weak var darkImg_out: DesignableImage!
    @IBOutlet weak var darkImg_Pswd: DesignableImage!
    
    @IBOutlet weak var textField_view_Outlet: DesignableView!
    
    @IBOutlet weak var passwrd_View_Outlet: DesignableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
        self.emailTxt.keyboardType = UIKeyboardType.emailAddress
        // Get notified every time the text changes, so we can save it
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(textFieldDidChange(_:)),
                                       name: Notification.Name.UITextFieldTextDidChange,
                                       object: nil)
     
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Address",attributes: [NSAttributedStringKey.foregroundColor: WHITE_COLOR])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: WHITE_COLOR])
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - BUTTON ACTIONS
    @IBAction func backBtnAct(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    func sague()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
        
        navigationController?.viewControllers = [vc]
    }
    
    // MARK: For Email
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailTxt.text)
     }
    
    //   MARK: TEXT FIELD DELEGATE FOR TEXT DID CHANGE...
   
    @objc func textFieldDidChange(_ sender: Any)
    {
        if let notification = sender as? Notification,
            let textFieldChanged = notification.object as? UITextField,
            textFieldChanged == self.emailTxt
        {
             if isValidEmail(testStr: textFieldChanged.text!) == true
            {
                self.darkImg_out.image = #imageLiteral(resourceName: "Success")
            }
            else
            {
                self.darkImg_out.image = #imageLiteral(resourceName: "error")
            }
    
        }
        else if let notification = sender as? Notification,
        let textFieldChanged = notification.object as? UITextField,
        textFieldChanged == self.passwordTxt
        {
            if textFieldChanged.text!.count >= 6 && textFieldChanged.text!.count <= 16
            {
                self.darkImg_Pswd.image = #imageLiteral(resourceName: "Success")
            }
            else
            {
                self.darkImg_Pswd.image = #imageLiteral(resourceName: "error")
            }
        }
        
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField)
//    {
//        print(textField.text as Any)
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if emailTxt == textField {
        textField_view_Outlet.backgroundColor = BLACK_COLOR
        } else if passwordTxt == textField {
            passwrd_View_Outlet.backgroundColor = BLACK_COLOR
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if emailTxt == textField {
            textField_view_Outlet.backgroundColor = UIColor.clear
        } else if passwordTxt == textField {
            passwrd_View_Outlet.backgroundColor = UIColor.clear
        }

       // self.setTextBorder(textField: textField, color: UIColor.lightGray)
    }
    
  //    MARK: Login_Button...
    @IBAction func loginBtnAct(_ sender: Any)
    {
//        self.sague()
       self.Validation1()
    }
    
    @IBAction func forgotPwdBtnAct(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPwdViewController") as! ForgotPwdViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:validation1 login
    func Validation1()
    {
        
        if emailTxt.text == "" && passwordTxt.text == ""
        {
            self.AlertMessage(AlertMessage: "Enter all Inputs")
            
        }
        else if emailTxt.text == ""         {
            self.AlertMessage(AlertMessage: "Enter Email First")
            
        }
        else if passwordTxt.text == ""
        {
            self.AlertMessage(AlertMessage: "Enter Password First")
        }
        else
        {
           self.loginApi()
            
        }
    }
    
    //MARK: ALERTMESSAGE...
    func AlertMessage(AlertMessage:String)
    {
        let alert = UIAlertController(title: "Alert", message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
     //MARK:-Login_Api
    
    func getParams() -> NSDictionary {
        
        let params = ["email": emailTxt.text!,
                      "password": passwordTxt.text!
        ]
        return params as NSDictionary
        
    }
    //MARK:LOGIN API
    func loginApi() {
      self.showProgress()
      WebService.webService.loginApi(vc: self, params: getParams()){ _ in
            //Utilities.ShowAlertView(title: "Alert", message: "Login Api Successfull", viewController: self)
            self.sague()
        
        }
    }
    
    
}
