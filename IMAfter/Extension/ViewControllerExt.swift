//
//  ViewController.swift
//  IMAfter
//
//  Created by MAC on 2/1/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


extension UIImageView {
    
    
    func setImage(url:String){
        
       
        self.setIndicatorStyle(.gray)
        self.setShowActivityIndicator(true)
        let path = URL(string:url)
        
        self.sd_setImage(with: path)
        
    }
    
}


extension UIViewController {
    
    //Web Service
    func webservicesPostRequest(baseString: String, parameters: [String:String],success:@escaping (_ response: NSDictionary)-> Void, failure:@escaping (_ error: Error) -> Void){
        
        let headers =
            [
                "content-type": "application/json",
            ]
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let jsonData = try? JSONSerialization.data(withJSONObject:parameters)
        
        let url = baseString
        
        print(url)
        print(parameters)
        
        var request = URLRequest(url: URL(string: url)!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil{
                if let responseData = data{
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        success(json as! NSDictionary)
                    }catch let err{
                        print(err)
                        failure(err)
                        
                    }
                }
            }else{
                failure(error!)
            }
        }
        dataTask.resume()
    }
    
    
    
}
