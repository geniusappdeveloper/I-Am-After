//
//  ViewControllerExtension.swift
//  LookMe
//
//  Created by SIERRA on 9/13/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {

    
    // show progress hud
    func showProgress() {
        // loader starts
        let size = CGSize(width: 50, height:50)
        self.startAnimating(size, message:"Loading", messageFont: UIFont.systemFont(ofSize: 18.0), type: NVActivityIndicatorType.ballSpinFadeLoader, color: UIColor.white, padding: 1, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }
    
    // hide progress hud
    func hideProgress() {
        // stop loader
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.stopAnimating() }
    }
    


}
