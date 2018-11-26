//
//  UIViewControllerExtension.swift
//  I’M After
//
//  Created by MAC on 11/6/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func RoundView(view:UIView){

        view.layer.cornerRadius = view.bounds.height / 2
        view.clipsToBounds = true
    }
    
    func RoundSpecificCorners(view:UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topRight], cornerRadii: CGSize(width: 7, height: 7)).cgPath
        view.layer.mask = rectShape
    }
    
    func RoundLeftCorners(view:UIView) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = view.frame
        rectShape.position = view.center
        rectShape.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 7, height: 7)).cgPath
        view.layer.mask = rectShape
    }
    

    // for alert
    func alert(title:String, message:String) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
