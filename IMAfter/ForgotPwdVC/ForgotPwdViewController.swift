//
//  ForgotPwdViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/17/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class ForgotPwdViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTxt: DesignableText!
    
    @IBOutlet weak var forgotpswddark_Img: DesignableImage!
    
    @IBOutlet weak var forgetpswrd_View_Outlet: DesignableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxt.delegate = self
        self.emailTxt.keyboardType = UIKeyboardType.emailAddress
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(textFieldDidChange(_:)),
                                       name: Notification.Name.UITextFieldTextDidChange,
                                       object: nil)

        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Address",attributes: [NSAttributedStringKey.foregroundColor: WHITE_COLOR])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.forgotpswddark_Img.image = #imageLiteral(resourceName: "Success")
            }
            else
            {
                self.forgotpswddark_Img.image = #imageLiteral(resourceName: "error")
            }
            
        }
        else
            {
                print("nothing to be happen")
            }
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        forgetpswrd_View_Outlet.backgroundColor = BLACK_COLOR
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        forgetpswrd_View_Outlet.backgroundColor = UIColor.clear
    }

    
    //MARK: ALERTMESSAGE...
    func AlertMessage(AlertMessage:String)
    {
        let alert = UIAlertController(title: "Alert", message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: For Email
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: emailTxt.text)
        
    }
    

    // MARK: - BUTTON ACTIONS
    @IBAction func backBtnAct(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func resetPwdBtnAct(_ sender: Any)
    {
        if emailTxt.text == ""
        {
            self.AlertMessage(AlertMessage: "Enter Email First")
        }else
        {
            self.Validation2()
        }
    }
    
    func Validation2()
    {
        if  isValidEmail(testStr: emailTxt.text!) == true
        {
            self.forgotpassword()
        }else
        {
            self.AlertMessage(AlertMessage: "Please enter valid email ")
        }
    }
    
    //Mark: ForgotPassword_Api...
    func forgotpassword() {
        self.showProgress()
        let params = ["email": self.emailTxt.text!,
                      ]
        
        WebService.webService.forgotpassword_Api(vc: self, params: params as NSDictionary){ _ in
            self.hideProgress()
            self.AlertMessage(AlertMessage: "Password Sent Successfully...")
            self.emailTxt.text = ""
            
        }
        
    }

}

