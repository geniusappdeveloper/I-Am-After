//
//  WelcomeVC.swift
//  I’M After
//
//  Created by MAC on 11/6/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet var workBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "user_id") as? String == nil
        {
            print("userid is nil")
        }else
        {
            
            self.sague()
            
        }

        self.setBtnText()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBtnText() {
        
        let firstNormalText = "How does "
        let firstAttrs = [NSAttributedStringKey.foregroundColor : UIColor.white,
                          NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
        let firstnormalString = NSMutableAttributedString(string:firstNormalText, attributes:firstAttrs)
        
        let boldText  = "Uniqq"
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.white,
                     NSAttributedStringKey.underlineStyle : 1] as [NSAttributedStringKey : Any]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        firstnormalString.append(attributedString)
        
        let secondNormalText = " work?"
        let secondNormalString = NSMutableAttributedString(string:secondNormalText, attributes:firstAttrs)
        firstnormalString.append(secondNormalString)
        
        workBtn.setAttributedTitle(firstnormalString, for: .normal)
    }
    
    func sague()
    {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil;

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        let vc = storyboard?.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
       // navigationController?.pushViewController(vc, animated: false)
        
        navigationController?.viewControllers = [vc]
    }


    @IBAction func btnContinue(_ sender: UIButton) {
  
        
    }
    @IBAction func btnlogin(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
