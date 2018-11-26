//
//  PostWantedViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/20/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class PostWantedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate , UITextFieldDelegate {
    
    @IBOutlet var post_label: UILabel!
    var imageData : Data!;
    var tempImageData : UIImage!;
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var category_Name = [String]()
    var selectedCate = String()
    var selectCate_Nam = String()
    var postprice = String()
    var category_id = NSMutableArray()
    var category_name = NSMutableArray()
    var selectCateId = String()
    
    
    @IBOutlet var amountTable: UITableView!
    @IBOutlet weak var uploadImg_out: UIImageView!
    @IBOutlet weak var imgView_out: UIView!
    @IBOutlet weak var wantedPost_Img: UIImageView!
    @IBOutlet var view_outlet: DesignableView!
    @IBOutlet weak var wantedpost_View: UITextView!
    @IBOutlet weak var descWantedpost_Img: UIImageView!
    @IBOutlet weak var descWantedpost_Views: UITextView!
    @IBOutlet weak var selectedCate_Img: UIImageView!
    @IBOutlet weak var selectItemNam_out: UILabel!
    @IBOutlet weak var priceRangeImg_out: UIImageView!
     @IBOutlet weak var categoryView_out: UIView!
     @IBOutlet weak var categoryTablevw_out: UITableView!
    
  //  @IBOutlet var Crossbtn_Out: DesignableButton!
    @IBOutlet var character_label: UILabel!
    @IBOutlet var postBtn_outlet: UIButton!
    @IBOutlet var post_label1: UILabel!
    var amount_Arr = ["Under £10", "£10 - £100", "£100 - £500", "£500 - £1000", "Over £1000"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(SingletonClass.sharedInstance.get_category_ids)
        self.category_id = (SingletonClass.sharedInstance.get_category_ids.value(forKey: "id") as! NSArray).mutableCopy() as! NSMutableArray
        
        self.category_name = (SingletonClass.sharedInstance.get_category_ids.value(forKey: "category_name") as! NSArray).mutableCopy() as! NSMutableArray
     
//        category_Name = ["Home & Garden", "Electronics", "Sports", "Collecttables & Arts", "Vehicles", "Mobiles"]
        selectedCate = "Yes"
//        wantedpost_View.text = "looking for..."
//        descWantedpost_Views.text = "what do you want to buy..."
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.categoryView_out.isHidden = true
        self.categoryTablevw_out.isHidden = true
        
       
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: ALERT MESSAGE...
    func AlertMessage(AlertMessage:String)
    {
        let alert = UIAlertController(title: "Alert", message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func postBtnAct(_ sender: Any)
    {
        if self.uploadImg_out.image == nil {
            self.AlertMessage(AlertMessage: "please select image first")
        }
        else
        {
            print("All is OK")
            self.postWanted_Api()
            //   uploadImg_out.image = nil
            //  wantedpost_View.text = ""
            // descWantedpost_Views.text = ""
            //   self.postprice = ""
            //    self.selectCateId = ""

            
        }
    }
    
    @IBAction func selectCategory_Btn(_ sender: Any)
    {
        if selectedCate == "Yes"
        {
                self.categoryView_out.isHidden = false
                self.categoryTablevw_out.isHidden = false
                    selectedCate = "No"
        }
        else
        {
                    self.categoryView_out.isHidden = true
                    self.categoryTablevw_out.isHidden = true
                    selectedCate = "Yes"
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
//        self.imgView_out.isHidden = true
        self.dismiss(animated: true, completion: nil);
        

    
    }
    
    //MARK: TABLE_VIEW DELEGATES....
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == amountTable
        {
        return amount_Arr.count
        }
        else
        {
            return self.category_id.count
        }
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
          let cell: PostAmountTableViewCell = amountTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostAmountTableViewCell
        
        if tableView == amountTable
        {
        let cell1: PostAmountTableViewCell = amountTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostAmountTableViewCell
        cell1.amountLbl.text = self.amount_Arr[indexPath.row]
            
            if self.postprice == self.amount_Arr[indexPath.row]{
                cell1.selectableImg.backgroundColor = UIColor(red: 43/255, green: 148/255, blue: 160/255, alpha: 1.0)



                
            }else{
                
                cell1.selectableImg.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)

                
            }
            
            
            return cell1
            
        }
        else
        {
        let cell2 = categoryTablevw_out.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostWantedCategory_TVC
            cell2.categoryName.text = self.category_name[indexPath.row] as! String
            return cell2
        }
        return cell
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == amountTable
        {
            self.postprice = self.amount_Arr[indexPath.row]
            amountTable.reloadData()
            
        }  else
        {
            let cell = categoryTablevw_out.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostWantedCategory_TVC
            print(cell)
            self.selectItemNam_out.text = self.category_name.object(at: indexPath.row) as! String
            self.selectCate_Nam = self.selectItemNam_out.text!
            print(self.selectCate_Nam)
            self.selectCateId = "\(self.category_id.object(at: indexPath.row) )"
            categoryTablevw_out.reloadData()
            self.categoryView_out.isHidden = true
            selectedCate = "Yes"
           
        }
        
        if self.selectCateId != "" && self.postprice != "" && wantedpost_View.text != nil && descWantedpost_Views.text != nil && uploadImg_out.image != nil
        {
            
            postBtn_outlet.isEnabled = true
          //  Crossbtn_Out.isEnabled = true
            self.view_outlet.backgroundColor = THEME_COLOR
          //  self.Crossbtn_Out.backgroundColor = THEME_COLOR
            self.view_outlet.layer.cornerRadius =  self.view_outlet.frame.height / 2
            self.view_outlet.clipsToBounds = true

            
        }
        else{
            
            postBtn_outlet.isEnabled = false
           // Crossbtn_Out.isEnabled = false
            view_outlet.backgroundColor = UIColor.btnColor
           // Crossbtn_Out.backgroundColor = UIColor.btnColor
            self.view_outlet.layer.cornerRadius =  self.view_outlet.frame.height / 2
            self.view_outlet.clipsToBounds = true
            
        }
        
    }
    
    //MARK: text view delegates...
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
//    {
//        if textView == wantedpost_View
//        {
//        if wantedpost_View.text == "looking for..."
//        {
//            wantedpost_View.text = ""
//
//        }else if wantedpost_View.text == ""
//        {
//            wantedpost_View.text = "looking for..."
//        }
//        }
//        else if textView == descWantedpost_Views
//        {
//            if descWantedpost_Views.text == "what do you want to buy..."
//            {
//                descWantedpost_Views.text = ""
//
//            }else if descWantedpost_Views.text == ""
//            {
//                descWantedpost_Views.text = "what do you want to buy..."
//            }
//        }
//
//
//        return true
//    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == wantedpost_View{
         
            let currentText = self.wantedpost_View.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            let remaingNumPost  = 160 - self.wantedpost_View.text.count
            self.post_label1.text = "\(remaingNumPost)"
            return changedText.count <= 160
            
    }
        
            if textView == descWantedpost_Views{

            let currentText = self.descWantedpost_Views.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            let remaingNumPost  = 1500 - self.descWantedpost_Views.text.count
            self.character_label.text = "\(remaingNumPost)"
            return changedText.count <= 1500
            
    }
        
        
      return false
        
        
}

    
//    func textViewDidEndEditing(_ textView: UITextView)
//    {
//        if textView == wantedpost_View
//        {
//            if wantedpost_View.text == "looking for..."
//            {
//                wantedpost_View.text = ""
//
//            }else if wantedpost_View.text == ""
//            {
//                wantedpost_View.text = "looking for..."
//            }
//        }
//        else if textView == descWantedpost_Views
//        {
//            if descWantedpost_Views.text == "what do you want to buy..."
//            {
//                descWantedpost_Views.text = ""
//
//            }else if descWantedpost_Views.text == ""
//            {
//                descWantedpost_Views.text = "what do you want to buy..."
//            }
//        }
//
//    }
//
    
//    MARK: PostWanted_API
    func postWanted_Api() {
        
        self.showProgress()
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("user_id is nil")
        }
        else
        {
            let params = ["user_id": "\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                          "post_title": self.wantedpost_View.text!,
                          "post_price": self.postprice,
                          "post_desc": self.descWantedpost_Views.text!,
                          "categorys_id": self.selectCateId
                
            ]
            
            print(params)
            
            
            WebService.webService.postwanted_Api(vc: self, imagedata: tempImageData, params: params as NSDictionary){ _ in
                self.hideProgress()
                
                let alert = UIAlertController(title: "Message", message: "Post Submitted Successfully", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action -> Void in
                    self.sague()
                    print("action are work....")
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
            
            
        }
    }

    
    //    @IBAction func selectableBtnAct(_ sender: UIButton) {
    //        if sender.image(for: .normal) == UIImage(named: "greenCircle") { // .backgroundColor == UIColor(red: 43/255, green: 148/255, blue: 160/255, alpha: 1.0) {
    //            sender.setImage(UIImage(named: "whiteCircle"), for: .normal)
    //            //sender.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
    //        }
    //        else {
    //            sender.setImage(UIImage(named: "greenCircle"), for: .normal)
    //           // sender.backgroundColor = UIColor(red: 43/255, green: 148/255, blue: 160/255, alpha: 1.0)
    //        }
    //    }
    
}

extension UIColor
{
    public class var btnColor: UIColor
    {
        return UIColor(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1.0)
    }
}










