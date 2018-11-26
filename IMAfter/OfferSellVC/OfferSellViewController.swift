//
//  OfferSellViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/18/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class OfferSellViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate {
    
    var imageData : Data!;
    var tempImageData : UIImage!;
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var postId = NSMutableArray()
    var selected_postId = String()

    @IBOutlet weak var uploadImg_out: UIImageView!
    
    @IBOutlet weak var darkImgPrice_out: UIImageView!
    
    @IBOutlet weak var postPrice_out: UITextField!
    
    @IBOutlet weak var darkImgDesc_out: UIImageView!
    
    @IBOutlet weak var textViewDesc_out: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.selected_postId)
        textViewDesc_out.text = "Tell the buyer some details about your item"
        textViewDesc_out.textColor = UIColor.lightGray

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
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.isFromOfferSellVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitOfferBtn_Act(_ sender: Any)
    {
        if self.uploadImg_out.image == nil {
            self.AlertMessage(AlertMessage: "please select image first")
        }
        else
        {
            print("All is OK")
            
            if self.postPrice_out.text! == "" {
                
                self.AlertMessage(AlertMessage: "please enter price.")
            }
            else if self.textViewDesc_out.text! == "Tell the buyer some details about your item"{
                
                self.AlertMessage(AlertMessage: "please write a message.")
            }
            else{
                
                self.offertoSell_Api()
            }
            
        }
       
    }
    
    @IBAction func uploadImg_Clicked(_ sender: Any)
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
        else
        {
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo editingInfo: [String : Any])
    {
        
        print(editingInfo as Any);
        
        tempImageData = editingInfo[UIImagePickerControllerEditedImage] as! UIImage
        
        print(tempImageData)
        
        self.uploadImg_out.image = tempImageData as UIImage;
        self.uploadImg_out.contentMode = .scaleAspectFill
        
        //self.profileImg.layer.cornerRadius = CGFloat(roundf(Float(self.profileImg.frame.size.width / 2)))
        imageData = UIImageJPEGRepresentation(tempImageData as UIImage, 1.0)
        self.dismiss(animated: true, completion: nil);
    }
    
    //MARK: ALERT MESSAGE...
    func AlertMessage(AlertMessage:String)
    {
        let alert = UIAlertController(title: "Alert", message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: OfferToSell_API
    func offertoSell_Api()
    {
        showProgress()
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }
        else
        {
            let params = ["user_id": "\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                          "post_id": self.selected_postId,
                          "post_price": "£" + self.postPrice_out.text!,
                          "post_desc": self.textViewDesc_out.text!
                         
        ]
            
            
            
            WebService.webService.offerToSell_Api(vc: self, imagedata: tempImageData, params: params as NSDictionary){ _ in
                self.hideProgress()
                
                print(SingletonClass.sharedInstance.offerTosell)
                
        SingletonClass.sharedInstance.ChatData = PostData(Name: "\(SingletonClass.sharedInstance.offerTosell.value(forKey: "friend_name") ?? "NA")",
            PostName: "\(SingletonClass.sharedInstance.offerTosell.value(forKey: "post_title") ?? "NA")",
            Time: "\(SingletonClass.sharedInstance.offerTosell.value(forKey: "friend_name") ?? "NA")",
            LastMessage: "\(SingletonClass.sharedInstance.offerTosell.value(forKey: "friend_name") ?? "NA")",
            friendPic: "\(SingletonClass.sharedInstance.offerTosell.value(forKey: "friend_image") ?? "NA")",
            PostID: "\(SingletonClass.sharedInstance.offerTosell.value(forKey: "post_id") ?? "NA")",
            friendID: "\(SingletonClass.sharedInstance.offerTosell.value(forKey: "post_user_id") ?? "NA")",
            messageCount: "\(SingletonClass.sharedInstance.offerTosell.value(forKey: "unreadmsg_count") ?? "0")")
                
                
                
        let alert = UIAlertController(title: "Message", message: "Offer Submitted Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action -> Void in
                    self.sague()
                    print("action are work....")
                    
                }))
                self.present(alert, animated: true, completion: nil)
       
            }
        }
    }
    
    //MARK: text field delegates...
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
//    {
//        if textViewDesc_out.text == "Post desc..."
//        {
//            textViewDesc_out.text = ""
//
//        }else if textViewDesc_out.text == ""
//        {
//            textViewDesc_out.text = "Post desc..."
//        }
//        return true
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView)
//    {
//        if textViewDesc_out.text == "Post desc..."
//        {
//            textViewDesc_out.text = ""
//
//        }else if textViewDesc_out.text == ""
//        {
//            textViewDesc_out.text = "Post desc..."
//        }
//
//
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewDesc_out.textColor == UIColor.lightGray {
            textViewDesc_out.text = ""
            textViewDesc_out.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewDesc_out.text.isEmpty {
            textViewDesc_out.text = "Tell the buyer some details about your item"
            textViewDesc_out.textColor = UIColor.lightGray
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

//        if let isEmpty = (postPrice_out.text?.isEmpty) {
//            if !isEmpty {
//            // postPrice_out textField is not empty
//                if let text = postPrice_out.text {
//                    if text.last == "£" {
//
//                        postPrice_out.text = text.replacingOccurrences(of: "£", with: "")
//
//                    }
//                }
//            }
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        if let isEmpty = (postPrice_out.text?.isEmpty) {
//            if !isEmpty {
//                postPrice_out.text = postPrice_out.text! + "£"
//            }
//        }
    }
    
 }










