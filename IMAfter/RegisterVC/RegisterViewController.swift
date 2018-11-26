//
//  RegisterViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/17/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate  {
    
    var imageData : Data!;
    var tempImageData : UIImage!;
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    
    //    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet var profileImg: DesignableImage!
    @IBOutlet var nameTxt: DesignableText!
    @IBOutlet var lastNameTxt: DesignableText!
    @IBOutlet var emailTxt: DesignableText!
    @IBOutlet var passwordTxt: DesignableText!
    @IBOutlet var passwordRepeatTxt: DesignableText!
    
    @IBOutlet weak var namdarkImg_out: DesignableImage!
    @IBOutlet weak var lastnamdarkImg_out: DesignableImage!
    @IBOutlet weak var emaildarkImg_out: DesignableImage!
    @IBOutlet weak var pswddarkImg_out: DesignableImage!
    @IBOutlet weak var confrmdarkImg_out: DesignableImage!
    
    @IBOutlet weak var name_View_Outlet: DesignableView!
    
    @IBOutlet weak var latname_View_Outlet: DesignableView!
    
    @IBOutlet weak var emailtxt_View_Outlet: DesignableView!
    
    @IBOutlet weak var paswrd_View_Outlet: DesignableView!
    
    @IBOutlet weak var repeatpswrd_View_outlet: DesignableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTxt.delegate = self
        lastNameTxt.delegate = self
        emailTxt.delegate = self
        passwordTxt.delegate = self
        passwordRepeatTxt.delegate = self
        // Get notified every time the text changes, so we can save it
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(textFieldDidChange(_:)),
                                       name: Notification.Name.UITextFieldTextDidChange,
                                       object: nil)
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: "First Name",attributes: [NSAttributedStringKey.foregroundColor: WHITE_COLOR])
        lastNameTxt.attributedPlaceholder = NSAttributedString(string: "Last Name",attributes: [NSAttributedStringKey.foregroundColor: WHITE_COLOR])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email Address",attributes: [NSAttributedStringKey.foregroundColor: WHITE_COLOR])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: WHITE_COLOR])
        passwordRepeatTxt.attributedPlaceholder = NSAttributedString(string: "Password Repeat",attributes: [NSAttributedStringKey.foregroundColor: WHITE_COLOR])
        
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
            textFieldChanged == self.nameTxt
        {
            if textFieldChanged.text! != ""
            {
                self.namdarkImg_out.image = #imageLiteral(resourceName: "Success")
            }
            else if textFieldChanged.text! == ""
            {
                self.namdarkImg_out.image = #imageLiteral(resourceName: "error")
            }
            else
            {
                self.namdarkImg_out.image = #imageLiteral(resourceName: "Dark")
            }
            
            
        }
        else if let notification = sender as? Notification,
            let textFieldChanged = notification.object as? UITextField,
            textFieldChanged == self.lastNameTxt
        {
            if textFieldChanged.text! != ""
            {
                self.lastnamdarkImg_out.image = #imageLiteral(resourceName: "Success")
            }
            else
            {
                self.lastnamdarkImg_out.image = #imageLiteral(resourceName: "error")
            }
            
        }
        else if let notification = sender as? Notification,
            let textFieldChanged = notification.object as? UITextField,
            textFieldChanged == self.emailTxt
        {
            if isValidEmail(testStr: textFieldChanged.text!) == true
            {
                self.emaildarkImg_out.image = #imageLiteral(resourceName: "Success")
            }
            else
            {
                self.emaildarkImg_out.image = #imageLiteral(resourceName: "error")
            }
        }
        else if let notification = sender as? Notification,
            let textFieldChanged = notification.object as? UITextField,
            textFieldChanged == self.passwordTxt
        {
            if textFieldChanged.text!.count >= 6
            {
                self.pswddarkImg_out.image = #imageLiteral(resourceName: "Success")
            }
            else
            {
                self.pswddarkImg_out.image = #imageLiteral(resourceName: "error")
            }
        }
        else if let notification = sender as? Notification,
            let textFieldChanged = notification.object as? UITextField,
            textFieldChanged == self.passwordRepeatTxt
        {
            if textFieldChanged.text!.count >= 6
            {
                self.confrmdarkImg_out.image = #imageLiteral(resourceName: "Success")
            }
            else
            {
                self.confrmdarkImg_out.image = #imageLiteral(resourceName: "error")
            }
            
            if self.passwordTxt.text! == self.passwordRepeatTxt.text!
            {
                self.confrmdarkImg_out.image = #imageLiteral(resourceName: "Success")
            }
            else
            {
                self.confrmdarkImg_out.image = #imageLiteral(resourceName: "error")
            }
            
            
        }
        else
        {
            print("nothing to be happen")
        }
        
        
        
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField)
//    {
//        print(textField.text as Any)
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if nameTxt == textField {
            name_View_Outlet.backgroundColor = BLACK_COLOR
        } else if lastNameTxt == textField {
            latname_View_Outlet.backgroundColor = BLACK_COLOR
        } else if emailTxt == textField {
            emailtxt_View_Outlet.backgroundColor = BLACK_COLOR
        } else if passwordTxt == textField {
            paswrd_View_Outlet .backgroundColor = BLACK_COLOR
        } else if passwordRepeatTxt == textField {
            repeatpswrd_View_outlet.backgroundColor = BLACK_COLOR
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if nameTxt == textField {
            name_View_Outlet.backgroundColor = UIColor.clear
        } else if lastNameTxt == textField {
            latname_View_Outlet.backgroundColor = UIColor.clear
        } else if emailTxt == textField {
            emailtxt_View_Outlet.backgroundColor = UIColor.clear
        } else if passwordTxt == textField {
            paswrd_View_Outlet .backgroundColor = UIColor.clear
        } else if passwordRepeatTxt == textField {
            repeatpswrd_View_outlet.backgroundColor = UIColor.clear
        }
        
        // self.setTextBorder(textField: textField, color: UIColor.lightGray)
    }
    
    // MARK: - BUTTON ACTIONS
    @IBAction func backBtnAct(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAcntBtnAct(_ sender: Any)
    {
        //        self.sague()
        self.Validation1()
    }
    
    func sague()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
        
        navigationController?.viewControllers = [vc]
    }
    
    //MARK: ALERTMESSAGE...
    func AlertMessage(AlertMessage:String)
    {
        let alert = UIAlertController(title: "Alert", message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: For Email
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: emailTxt.text)
        
    }
    
    //    MARK: FOR VALIDATIONS
    
    func Validation1()
    {
        if nameTxt.text == "" && lastNameTxt.text == "" && emailTxt.text == "" && passwordTxt.text == "" && passwordRepeatTxt.text == ""
        {
            self.AlertMessage(AlertMessage: "Enter all Inputs")
        }
        else
        {
            print("All is OK")
            self.Validation2()
        }
    }
    
    func Validation2()
    {
        if  isValidEmail(testStr: emailTxt.text!) == true 
        {
            self.checkpassword()
            self.registerApi()
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
    }
    
    //MARK: For check password same or not...
    func checkpassword()
    {
        if passwordTxt.text! == passwordRepeatTxt.text!
        {
            print("Password is Same")
            
        }
        else
        {
            print("Password not same")
            let alert = UIAlertController(title: "Alert", message: "Password are not same", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: {action -> Void in
                
                print("action are work....")
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Profile uploading action sheet button....
    @IBAction func profileImg_Clicked(_ sender: Any)
    {
        self.CameraActionSheet()
    }
    
    func CameraActionSheet()
    {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.opencamera()
        })
        let saveAction = UIAlertAction(title: "Select existing photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallery()
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        // Add the actions
        imagePicker?.delegate = self
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func opencamera()
    {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker!.allowsEditing = true
            imagePicker!.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo;
            self.present(imagePicker!, animated: true, completion: nil)
        }
        else
        {
            print("Sorry cant take picture")
            let alert = UIAlertController(title: "Warning", message:"Camera is not working.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func openGallery()
    {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker!.allowsEditing = true
            self.present(imagePicker!, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo editingInfo: [String : Any])
    {
        
        print(editingInfo as Any);
        
        tempImageData = editingInfo[UIImagePickerControllerEditedImage] as! UIImage
        
        print(tempImageData)
        self.profileImg.image = tempImageData as UIImage;
        self.profileImg.contentMode = .scaleAspectFill
        //        self.profileImg.layer.cornerRadius = CGFloat(roundf(Float(self.profileImg.frame.size.width / 2)))
        imageData = UIImageJPEGRepresentation(tempImageData as UIImage, 1.0)
        self.dismiss(animated: true, completion: nil);
    }
    
    //MARK: TEXT FIELD DELEGATES
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
       
        if textField == emailTxt || textField == passwordTxt || textField == passwordRepeatTxt{
            return true
        } else {
        let characterSet = CharacterSet.letters
        
        if string.rangeOfCharacter(from: characterSet.inverted) != nil {
            return false
        }
        return true
      }
    }
    // MARK: REGISTER API
    func registerApi() {
        
 //       if tempImageData == nil {
            
  //          alert(title: "Alert", message: "Please select image first")
            
  //          return
   //     }
        
        self.showProgress()
        let params = ["first_name": nameTxt.text!,
                      "last_name": lastNameTxt.text!,
                      "email": emailTxt.text!,
                      "password": passwordTxt.text!,
                      "confirm_password": passwordRepeatTxt.text!,
                      ]
        
        
        WebService.webService.registerApi(vc: self, params: params as NSDictionary, imageData: tempImageData){ _ in
            self.hideProgress()
            
            let alert = UIAlertController(title: "Message", message: "Registered Successfully", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action -> Void in
                
                self.sague()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}
