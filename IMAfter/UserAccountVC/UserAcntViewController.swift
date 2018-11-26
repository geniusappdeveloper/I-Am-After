//
//  UserAcntViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/18/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class UserAcntViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageData : Data!;
    var tempImageData : UIImage!;
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var checktext = String()

    @IBOutlet var userAcntTable: UITableView!
    @IBOutlet var edit_btn_out: UILabel!
    @IBOutlet var userImg_out: DesignableImage!
    @IBOutlet var userNam_out: UITextField!
    @IBOutlet var userId_out: UITextField!
    @IBOutlet var userImBtn_out: UIButton!
    
    var title_Arr = ["Settings", "Send Us Feedback", "Log Out"]
    var img_Arr = ["setting", "msg", "logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userAcntTable.tableFooterView = UIView()
        checktext = "Yes"
        edit_btn_out.text = "Edit"
        self.userImg_out.isUserInteractionEnabled = false
        self.userNam_out.isUserInteractionEnabled = false
        self.userId_out.isUserInteractionEnabled = false
        self.userImBtn_out.isUserInteractionEnabled = false
        self.get_account_Api()
        
        if let user_imageUrl = UserDefaults.standard.string(forKey: "user_image") {
            let searchURL : NSURL = NSURL(string: user_imageUrl as String)!
            self.userImg_out.sd_setImage(with:searchURL as URL!, placeholderImage: nil)
        }
        if let unique_id = UserDefaults.standard.string(forKey: "unique_id") {
            
            self.userId_out.text = unique_id
        }
        if let user_name = UserDefaults.standard.string(forKey: "user_name") {
            
            self.userNam_out.text = user_name
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title_Arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UserAcntTableViewCell = self.userAcntTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserAcntTableViewCell
        
        cell.titleLbl.text = title_Arr[indexPath.row]
        cell.titleImg.image = UIImage(named: img_Arr[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userAcntTable.deselectRow(at: indexPath, animated: false)
        
        if title_Arr[indexPath.row] == "Log Out" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            
            UserDefaults.standard.removeObject(forKey: "user_id")
            UserDefaults.standard.synchronize()
          //  navigationController?.pushViewController(vc, animated: false)
            navigationController?.viewControllers = [vc]
        }
    }
    
    //MARK: EDIT BUTTON...
    @IBAction func edit_Clicked(_ sender: Any)
    {
        if checktext == "Yes"
        {
            edit_btn_out.text = "Done"
            self.userImg_out.isUserInteractionEnabled = true
            self.userNam_out.isUserInteractionEnabled = true
            self.userId_out.isUserInteractionEnabled = true
            self.userImBtn_out.isUserInteractionEnabled = true
            checktext = "No"
        }
        else
        {
             edit_btn_out.text = "Edit"
             self.update_account_Api()
             checktext = "Yes"
        }
        
    }
    
    //MARK: ALERT MESSAGE...
    func AlertMessage(AlertMessage:String)
    {
        let alert = UIAlertController(title: "Alert", message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Upload image from action sheet....
  @IBAction func uploadImg_clicked(_ sender: Any)
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
        self.userImg_out.image = tempImageData as UIImage;
        self.userImg_out.contentMode = .scaleAspectFill
        //        self.profileImg.layer.cornerRadius = CGFloat(roundf(Float(self.profileImg.frame.size.width / 2)))
        imageData = UIImageJPEGRepresentation(tempImageData as UIImage, 1.0)
        self.dismiss(animated: true, completion: nil);
    }
    
    //MARK: UpdateAccount_Api...
    func update_account_Api()
    {
        self.showProgress()
        let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as? String as Any,
                      "user_name": self.userNam_out.text!
                     
                      ]
        
        WebService.webService.Update_AccountApi(vc: self, imagedata: tempImageData, params: params as NSDictionary){ _ in
            self.hideProgress()
            self.AlertMessage(AlertMessage: "Account Updated Successfully...")
            self.get_account_Api()
            
            
        }
        
    }
  
    // MARK: GetAccount_Api...
    func get_account_Api()
    {
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }
        else
        {
            let params = ["user_id": UserDefaults.standard.value(forKey: "user_id") as? String as Any,
                        
            ]
            WebService.webService.getAccount_Api(vc: self, params: params as NSDictionary){ _ in
                print(SingletonClass.sharedInstance.get_account)
                print("Get Accpount Api is Updated")
                
                let userName = SingletonClass.sharedInstance.get_account.value(forKey: "user_name") as! NSArray
              
                 self.userNam_out.text = (userName[0] as! String)
                
                let userId = SingletonClass.sharedInstance.get_account.value(forKey: "unique_id") as? NSArray
                
                self.userId_out.text = (userId![0] as! String)
                
                let userImage =  SingletonClass.sharedInstance.get_account.value(forKey: "user_image") as! NSArray
                
                let url : NSString = (userImage[0] as! NSString)
                
                let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                let searchURL : NSURL = NSURL(string: urlStr as String)!
                print(searchURL)
                
                do
                {
                    let imageData = try Data(contentsOf: searchURL as URL)
                    self.tempImageData = UIImage(data: imageData)
                } catch {
                    print("Unable to load data: \(error)")
                }
                
//                if "\(searchURL)" == "https://iamafter.s3.eu-west-2.amazonaws.com/profile_images/default.png" {
//                    UserDefaults.standard.set("", forKey: "user_image");
//                    self.userImg_out.sd_setImage(with:NSURL(string: "" as String)! as URL!, placeholderImage: #imageLiteral(resourceName: "placeholderImg"))
//                }else{
                    UserDefaults.standard.set("\(urlStr)", forKey: "user_image");
                    self.userImg_out.sd_setImage(with:searchURL as URL!, placeholderImage: #imageLiteral(resourceName: "placeholderImg"))
//                }
                UserDefaults.standard.set("\(userId![0])", forKey: "unique_id");
                UserDefaults.standard.set("\(userName[0])", forKey: "user_name");
                
                print(self.tempImageData)
                
                self.userImg_out.setShowActivityIndicator(true)
                self.userImg_out.setIndicatorStyle(.gray)
                self.userImBtn_out.isUserInteractionEnabled = false
                self.userNam_out.isUserInteractionEnabled = false
                self.userId_out.isUserInteractionEnabled = false
                
          }
        
    }
    }
    
}
