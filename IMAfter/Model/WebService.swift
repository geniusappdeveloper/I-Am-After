 //
//  WebService.swift
//  IMAfter
//
//  Created by SIERRA on 11/29/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import Foundation
import Alamofire
 
struct WebService {
    
    static let webService = WebService()
    
    func httpRequest(methodName : String,params : NSDictionary, completion: @escaping (_ response:Any?,_ error:String?)->()) {
        
        
        print("Http Request params \(params)")
        //        params.setValue(methodName, forKeyPath: "action")
        
        
        //        let paramMutable = NSMutableDictionary(dictionary: params)
        //        paramMutable.setValue(methodName, forKey: "action")
        //
        //        print("Http Request MUTABLE params \(paramMutable)")
        print(API_BASE_URL+methodName)
        Alamofire.request(API_BASE_URL+methodName, method:.post, parameters: params as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch(response.result) {
                
            // api is hit successfully
            case .success(_):
                
                // if error in data parsed from api response
                // check status
                guard let data : NSDictionary = response.result.value as! NSDictionary? else {
                    
                    // if error in getting data from response
                    print("Api Hit Successfully, Parsing Data Error")
                    completion(nil,API_PARSING_ERROR)
                    return
                }
                // api hit successfully and parsing is good
                print("Api Hit Successfully, Response \(data)")
                
                // check if status is 0 or 1
                
                guard let status =  Int((data.value(forKey: "status") as! String)), status == 1 else {
                    
                    // if status is 0
                    //  print("Status \(status)")
                    // print("Message \(data.value(forKey: "message"))")
                    
                    
                    completion(nil,data.value(forKey: "message") as! String?)
                    return
                }
                // if status is 1, pass the dictionary back to caller
                completion(data.value(forKey: "result"),nil)
                
                break
                
            //  api hit failure
            case .failure(_):
                print("Api Hit Failure\(response.result.error!.localizedDescription)")
                // error is passed as string , response is kept nil
                
                completion(nil,API_HIT_FAILURE)
                
                break
                
            }
        }
     }
    
    func httpRequestforBadges(methodName : String,params : NSDictionary, completion: @escaping (_ response:Any?,_ error:String?)->()) {
        
        
        print("Http Request params \(params)")
        //        params.setValue(methodName, forKeyPath: "action")
        
        
        //        let paramMutable = NSMutableDictionary(dictionary: params)
        //        paramMutable.setValue(methodName, forKey: "action")
        //
        //        print("Http Request MUTABLE params \(paramMutable)")
        print(API_BASE_URL+methodName)
        Alamofire.request(API_BASE_URL+methodName, method:.post, parameters: params as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch(response.result) {
                
            // api is hit successfully
            case .success(_):
                
                // if error in data parsed from api response
                // check status
                guard let data : NSDictionary = response.result.value as! NSDictionary? else {
                    
                    // if error in getting data from response
                    print("Api Hit Successfully, Parsing Data Error")
                    completion(nil,API_PARSING_ERROR)
                    return
                }
                // api hit successfully and parsing is good
                print("Api Hit Successfully, Response \(data)")
                
                // check if status is 0 or 1
                
                guard let status =  Int((data.value(forKey: "status") as! String)), status == 1 else {
                    
                    // if status is 0
                    //  print("Status \(status)")
                    // print("Message \(data.value(forKey: "message"))")
                    
                    
                    completion(nil,data.value(forKey: "message") as! String?)
                    return
                }
                // if status is 1, pass the dictionary back to caller
                completion(data,nil)
                
                break
                
            //  api hit failure
            case .failure(_):
                print("Api Hit Failure\(response.result.error!.localizedDescription)")
                // error is passed as string , response is kept nil
                
                completion(nil,API_HIT_FAILURE)
                
                break
                
            }
        }
    }
    
    //MARK: Image Uploading
    
    func httpRequestWithImage(methodName : String,image : UIImage,imageName : String? = nil,resolution : Float? = nil, params : NSDictionary, completion: @escaping (_ response:Any?,_ error:String?)->()) {
        
        
        var imageToUploadName = "image"
        if(imageName != nil) {
            imageToUploadName = imageName!
        }
        
        var imageResolution : Float = 0.2
        if(resolution != nil) {
            
            imageResolution = resolution!
            
        }
        
        Alamofire.upload(multipartFormData: {
            
            (multipartFormData) in
            
            multipartFormData.append(UIImageJPEGRepresentation(image, CGFloat(imageResolution))!, withName: imageToUploadName, fileName: "file.jpeg", mimeType: "image/jpeg")
            
            
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        },
                         to:API_BASE_URL+methodName) {
                            
                            (result) in
                            
                            switch result {
                                
                            // api hit success
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress(closure: { (progress) in
                                    //Print progress
                                    print("Progress \(progress.description)")
                                })
                                
                                upload.responseJSON { response in
                                    //print response.result
                                    guard let data : NSDictionary = response.result.value as! NSDictionary? else {
                                        
                                        // if error in getting data from response
                                        print("Api Hit Successfully, Parsing Data Error")
                                        completion(nil,API_PARSING_ERROR)
                                        return
                                    }
                                    // api hit successfully and parsing is good
                                    print("Api Hit Successfully, Response \(data)")
                                    
                                    // check if status is 0 or 1
                                    
                                    guard let status =  Int((data.value(forKey: "status") as! String)), status == 1 else {
                                        
                                        // if status is 0
                                        //  print("Status \(status)")
                                        // print("Message \(data.value(forKey: "message"))")
                                        completion(nil,data.value(forKey: "message") as! String?)
                                        return
                                    }
                                    // if status is 1, pass the dictionary back to caller
                                    completion(data.value(forKey: "result"),nil)
                                }
                                
                            case .failure(_):
                                
                                completion(nil,API_HIT_FAILURE)
                                break
                                //print encodingError.description
                            }
        }
    }
    
    
    //MARK: Image Uploading
    
    func httpRequestWithMultipleImages(methodName : String,images : [UIImage],imageName : [String] ,resolution : Float? = nil, params : NSDictionary, completion: @escaping (_ response:Any?,_ error:String?)->()) {
        
        
        var imageResolution : Float = 0.2
        if(resolution != nil) {
            
            imageResolution = resolution!
            
        }
        
        Alamofire.upload(multipartFormData: {
            
            (multipartFormData) in
            
            
            for i in 0..<images.count {
                
                multipartFormData.append(UIImageJPEGRepresentation(images[i], CGFloat(imageResolution))!, withName: imageName[i], fileName: "file.jpeg", mimeType: "image/jpeg")
                
            }
            
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
        },
                         to:API_BASE_URL+methodName) {
                            
                            (result) in
                            
                            switch result {
                                
                            // api hit success
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress(closure: { (progress) in
                                    //Print progress
                                    print("Progress \(progress.description)")
                                })
                                
                                upload.responseJSON { response in
                                    //print response.result
                                    guard let data : NSDictionary = response.result.value as! NSDictionary? else {
                                        
                                        // if error in getting data from response
                                        print("Api Hit Successfully, Parsing Data Error")
                                        completion(nil,API_PARSING_ERROR)
                                        return
                                    }
                                    // api hit successfully and parsing is good
                                    print("Api Hit Successfully, Response \(data)")
                                    
                                    // check if status is 0 or 1
                                    
                                    guard let status =  Int((data.value(forKey: "status") as! String)), status == 1 else {
                                        
                                        // if status is 0
                                        //  print("Status \(status)")
                                        // print("Message \(data.value(forKey: "message"))")
                                        completion(nil,data.value(forKey: "message") as! String?)
                                        return
                                    }
                                    // if status is 1, pass the dictionary back to caller
                                    completion(data.value(forKey: "result"),nil)
                                }
                                
                            case .failure(_):
                                
                                completion(nil,API_HIT_FAILURE)
                                break
                                //print encodingError.description
                            }
        }
    }
    
    //MARK:- LOGIN API
    
    func loginApi (vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: Login, params:params as NSDictionary ) {
            
            response,error in
                    vc.hideProgress()
            
            // if no error
            if(response != nil) {
                 let item = response as! NSArray
        
                // todo with response
                print("TODO with response \(item)")
                
                let userId = "\((item[0] as AnyObject).value(forKey: "user_id") ?? "")"
          //      let _:String! = (item[0] as AnyObject).value(forKey: "unique_id") as! String
                
                SingletonClass.sharedInstance.user_id = userId
                UserDefaults.standard.set(userId, forKey: "user_id");
                UserDefaults.standard.synchronize()
                
                //                SingletonClass.sharedInstance.user_Id = UserDefaults.standard.string(forKey: "user_id")
                 completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else {
                //                 completion (false)
                //             vc.alert(title: "Error", message: error!)
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
    }
    
    //MARK:- RESGISTER API
    func registerApi (vc:UIViewController,params:NSDictionary,imageData: UIImage? = nil,completion: @escaping (_ isCompleted : Bool)->()) {
   
        if imageData != nil
        {
            WebService.webService.httpRequestWithImage(methodName : Register,image : imageData!,imageName : "profile_pic",resolution : 0.2, params : params) {
                response,error in
                
          
                // if no error
                if(error == nil) {
                    vc.hideProgress()
                    let item = response as! NSArray
                     // todo with response
                    print("TODO with response \(item)")
                    
                    let userId:String! = "\((item[0] as AnyObject).value(forKey: "user_id") ?? "NA")"
                   // let _:String! = (item[0] as AnyObject).value(forKey: "unique_id") as! String
                    
                    SingletonClass.sharedInstance.user_id = userId
                    UserDefaults.standard.set(userId, forKey: "user_id");
                    UserDefaults.standard.synchronize()
                    
                    completion (true)
                }
                    // error
                else {
                    vc.hideProgress()
                    Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                }
            }
        }
                
        
        else
        {
        WebService.webService.httpRequest(methodName: Register, params:params as NSDictionary ) {
            
            response,error in
            
            if(response != nil) {
                                vc.hideProgress()
                
                let item = response as! NSArray
                // todo with response
                print("TODO with response \(item)")
                let userID :String! =  "\((item[0] as AnyObject).value(forKey: "user_id") ?? "")"
                
                SingletonClass.sharedInstance.user_id = userID
                print(SingletonClass.sharedInstance.user_id)
                
                UserDefaults.standard.set(userID, forKey: "user_id");
                UserDefaults.standard.synchronize()
                completion (true)
            }
                
            else {
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
        }
    }
    
    //MARK:- Forgot_Password_Api
    
    func forgotpassword_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: ForgotPassword, params:params as NSDictionary ) {
            
            response,error in
            
                        vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                
                let item = response as! NSDictionary
                // todo with response
                print("TODO with response \(item)")
                
                
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else {
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
    }
    
    //MARK:- saved_post_API(this saved post api is used for save the post clicking on star button in home screen)
    
    func saved_post_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: Saved_Post, params:params as NSDictionary ) {
            
            response,error in
            
            vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                
                let saved_post = response as! NSDictionary
                // todo with response
                print("TODO with response \(saved_post)")
                 completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else {
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
            }
        }
    }
    
    //MARK:- Saved_Post_Details_API(saved post details api on my saved screen)
    
    func savedPost_DetailsApi(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: SavedPost_Details, params:params as NSDictionary ) {
            
            response,error in
            
            vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                print(response)
                let saved_post_Details = response as! NSDictionary
                // todo with response
                print("TODO with response \(saved_post_Details)")
                SingletonClass.sharedInstance.saved_post_details = saved_post_Details
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else {
                vc.hideProgress()
                //Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
            }
        }
    }
    
    //MARK:- Wanted_Post_Details_API(wanted post details api on my wanted screen)
    
    func wantedPost_DetailsApi(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        //  hit api
        //  vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: WantedPost_Details, params:params as NSDictionary ) {
            
            response,error in
            
            vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                print(response as Any)

                if  let wanted_post_Details = response as? NSDictionary {
                // todo with response
                print(wanted_post_Details)
                    SingletonClass.sharedInstance.saved_post_details = wanted_post_Details
                completion (true)
                
            }
                // show alert
                // push to next screen
            }
                // error
            else {
                vc.hideProgress()
                
                completion (false)

                //Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
            }
        }
    }
    
    //MARK:- Update_UserLoc_Api
    
    func UpdateLoc_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: UpdateLocation, params:params as NSDictionary ) {
            
            response,error in
            
                       vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                
                let item = response as! NSDictionary
                // todo with response
                print("TODO with response \(item)")
                
                
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else
            {
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
    }
    
    //MARK:- Search_Post_Api...
    
    func searchPost_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: Search_Post, params:params as NSDictionary ) {
            
            response,error in
            
            vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                
                let search_Post = (response as! NSArray).mutableCopy() as! NSMutableArray
                // todo with response
                print("TODO with response \(search_Post)")
                
                SingletonClass.sharedInstance.get_all_post = search_Post
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else
                
            {
                SingletonClass.sharedInstance.get_all_post = []
                completion (true)
                
                vc.hideProgress()
               // Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
    }
    
    //MARK:- Offer_To_Sell_Api

       
        func offerToSell_Api(vc:UIViewController,imagedata:UIImage? = nil,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
            
            if imagedata == nil {
                WebService.webService.httpRequest(methodName: Offer_to_Sell, params:params as NSDictionary ) {
                    response,error in
                    
                    // if no error
                    if(response != nil) {
                        let offer_to_sell = response as! NSDictionary
                        // todo with response
                        print("TODO with response \(offer_to_sell)")
                        SingletonClass.sharedInstance.offerTosell = offer_to_sell
                        completion (true)
                    }
                        // error
                    else {
                        print("Error in image")
                    }
                }
            }
            else {
                WebService.webService.httpRequestWithImage(methodName : Offer_to_Sell,image : imagedata!,imageName : "post_image",resolution : 0.2, params : params) {
                    response,error in
                    vc.hideProgress()
                    
                    // if no error
                    if(error == nil) {
                        let offer_to_sell = response as! NSDictionary
                        // todo with response
                        print("TODO with response \(offer_to_sell)")
                        SingletonClass.sharedInstance.offerTosell = offer_to_sell
                        completion (true)
                    }
                        // error
                    else {
                        vc.hideProgress()
                        Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                    }
                }
            }
        }
        

    
    //MARK:- Delete Offer OR Post_Api
    
    func deleteOffer_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: Delete_Post, params:params as NSDictionary ) {
            
            response,error in
            
            vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                let delete_Offer = response as! NSDictionary
                // todo with response
                print("TODO with response \(delete_Offer)")
                SingletonClass.sharedInstance.deleteOffer = delete_Offer
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else
            {
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
    }
    
    //MARK:-  Close_Post_Api
    
    func closePost_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: Close_Post, params:params as NSDictionary ) {
            
            response,error in
            
            vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                let close_post = response as! NSDictionary
                // todo with response
                print("TODO with response \(close_post)")
                SingletonClass.sharedInstance.close_Post = close_post
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else
            {
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
    }
    
     //MARK:- Update_Account_Api
    func Update_AccountApi(vc:UIViewController,imagedata:UIImage? = nil,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        if imagedata == nil {
            WebService.webService.httpRequest(methodName: Update_Account, params:params as NSDictionary ) {
                response,error in
                
                // if no error
                if(response != nil) {
                    let update_account = response as! NSArray
                    // todo with response
                    print("TODO with response \(update_account)")
                    
                    
                    completion (true)
                }
                    // error
                else {
                    print("Error in image")
                }
            }
        }
        else {
            WebService.webService.httpRequestWithImage(methodName : Update_Account,image : imagedata!,imageName : "user_image",resolution : 0.2, params : params) {
                response,error in
                 vc.hideProgress()
                
                // if no error
                if(error == nil) {
                    let update_account = response as! NSArray
                    // todo with response
                    print("TODO with response \(update_account)")
                     SingletonClass.sharedInstance.update_account = update_account
                    completion (true)
                }
                    // error
                else {
                    vc.hideProgress()
                    Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                }
            }
        }
    }
    
    //MARK:- Get_Account_Api
    
    func getAccount_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: Get_Account, params:params as NSDictionary ) {
            
            response,error in
            
            vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                let get_Account = response as! NSArray
                // todo with response
                print("TODO with response \(get_Account)")
                SingletonClass.sharedInstance.get_account = get_Account
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else
            {
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
    }
    
    //MARK:- POST_WANTED_API
    
    func postwanted_Api(vc:UIViewController,imagedata:UIImage? = nil,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
    if imagedata == nil {
                WebService.webService.httpRequest(methodName: Post_Wanted, params:params as NSDictionary ) {
                    response,error in
                    
                    // if no error
                    if(response != nil) {
                        let post_wanted = response as! NSDictionary
                                        // todo with response
                                        print("TODO with response \(post_wanted)")
                                        SingletonClass.sharedInstance.post_wanted = post_wanted
                        completion (true)
                    }
                        // error
                    else {
                        print("Error in image")
                    }
                }
            }
            else {
                WebService.webService.httpRequestWithImage(methodName : Post_Wanted,image : imagedata!,imageName : "post_image",resolution : 0.2, params : params) {
                    response,error in
                    vc.hideProgress()
                    
                    // if no error
                    if(error == nil) {
                        if let post_wanted = response as? NSDictionary {
                        // todo with response
                        print("TODO with response \(post_wanted)")
                        SingletonClass.sharedInstance.post_wanted = post_wanted
                        }
                        completion (true)
                    }
                        // error
                    else {
                        vc.hideProgress()
                        Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                    }
                }
            }
        }
    
    
    //MARK: Device_Token_API.....
    func device_token_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        WebService.webService.httpRequestforBadges(methodName: DeviceUpdate, params:params as NSDictionary ) {
            
            response,error in
            
            print(response)
            if(response != nil) {
                let devicetoken_details =  response as! NSDictionary
                //let totalMessageCount = "\(devicetoken_details.value(forKey: "msg_count") ?? "0")"
                
                NotificationCenter.default.post(name: Notification.Name("RefreshList"), object:devicetoken_details)
                
                // todo with response
                print("TODO with response \(devicetoken_details)")
                
                completion (true)
                
            }
                
            else {
                
            }
            
        }
    }
    
    //MARK: GetCategoryId_API.....
    func getcategoryid_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        WebService.webService.httpRequest(methodName: Get_CategorysId, params:params as NSDictionary ) {
            
            response,error in
            
            if(response != nil) {
                let getCategory_Ids =  response as! NSArray
                
                // todo with response
                print("TODO with response \(getCategory_Ids)")
                
                SingletonClass.sharedInstance.get_category_ids = getCategory_Ids
                print(SingletonClass.sharedInstance.get_category_ids)
                
                completion (true)
                
            }
                
            else {
                
            }
            
        }
    }
    
    //MARK:- Get_All_Post_Api
    
    func getAllPost_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        
        Alamofire.request(API_BASE_URL+Get_All_Post, method:.post, parameters: params as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch(response.result) {
                
            // api is hit successfully
            case .success(_):
                
                // if error in data parsed from api response
                // check status
                guard let data : NSDictionary = response.result.value as! NSDictionary? else {
                    
                    // if error in getting data from response
                    print("Api Hit Successfully, Parsing Data Error")
                  
                    return
                }
                // api hit successfully and parsing is good
                print("Api Hit Successfully, Response \(data)")
                
                // check if status is 0 or 1
                
               
                
                if let status =  Int((data.value(forKey: "status") as! String)), status == 1 {
                    
                                vc.hideProgress()
                    
                                // if no error
                                if(data != nil) {
                                    let tempDict = data as! NSDictionary
                                    print(tempDict)
                                    
                                    var GroupsTemp = NSMutableArray()
                                    GroupsTemp = ((tempDict.value(forKeyPath: "result") as! NSArray).mutableCopy() as! NSMutableArray)
                                    
                                     let counts = "\(tempDict.value(forKey: "post_count") ?? "")"
                                    
                                    SingletonClass.sharedInstance.all_post_Count = counts
                                    SingletonClass.sharedInstance.get_all_post = GroupsTemp
                                     completion (true)
                    
                                    // show alert
                                    // push to next screen
                                }
                    
                    return
                }
                else{
                      vc.hideProgress()
                }
                // if status is 1, pass the dictionary back to caller
              
              
                
            //  api hit failure
            case .failure(_):
                print("Api Hit Failure\(response.result.error!.localizedDescription)")
                // error is passed as string , response is kept nil
                vc.hideProgress()
                        Utilities.ShowAlertView2(title: "Alert", message: "", viewController: vc)
            
                
                break
                
            }
        }
      
//        WebService.webService.httpRequest(methodName: Get_All_Post, params:params as NSDictionary ) {
//
//            response,error in
//
//            vc.hideProgress()
//
//            // if no error
//            if(response != nil) {
//
//                let get_all_post = response as! NSArray
//                // todo with response
//                print("TODO with response \(get_all_post)")
//
//              SingletonClass.sharedInstance.get_all_post = get_all_post
//                 completion (true)
//
//                // show alert
//                // push to next screen
//            }
//                // error
//            else
//            {
//
//
//            }
//
//        }
    }
    
    //MARK:- Get_All_Post_Categories_API
    
    func getall_postCategories_Api(vc:UIViewController,params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //        vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: GetAll_PostCategories, params:params as NSDictionary ) {
            
            response,error in
            
            vc.hideProgress()
            
            // if no error
            if(response != nil) {
                
                let getall_postCategories = response as! NSArray
                // todo with response
                print("TODO with response \(getall_postCategories)")
                
                SingletonClass.sharedInstance.getall_postCategories = getall_postCategories
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else
            {
                vc.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: error!, viewController: vc)
                
            }
            
        }
    }
    
    //MARK: FACEBOOK_INTEGRATION...
    func facebook_loginApi(params:NSDictionary,completion: @escaping (_ isCompleted : Bool)->()) {
        
        // hit api
        //                vc.showProgress(title: "Processing Request...")
        WebService.webService.httpRequest(methodName: Facebook_Login, params:params as NSDictionary ) {
            
            response,error in
            
            //                       vc.hideProgress()
            
            // if no error
            if(response != nil) {
                let detail = response as! NSArray
                // todo with response
                print("TODO with response \(detail)")
                
                let userID  = "\((detail[0] as AnyObject).value(forKey: "user_id") ?? "NA")"
                
                SingletonClass.sharedInstance.user_id = userID
                print(SingletonClass.sharedInstance.user_id)
                
                UserDefaults.standard.set(userID, forKey: "user_id");
                UserDefaults.standard.synchronize()
                completion (true)
                
                // show alert
                // push to next screen
            }
                // error
            else {
                
            //vc.alert(title: "Error", message: error!)
                
            }
            
        }
    }
    
    
}
