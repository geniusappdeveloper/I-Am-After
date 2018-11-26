//
//  FilterViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/17/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

protocol SendDataBack {
    func arrayList(selectedArray: [String])
}


class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var filterTable: UITableView!
    var SelectedArray = [String]()
    var tempArr = [Any]()
    var delegate :SendDataBack?
    var isAllCatSelected :Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SingletonClass.sharedInstance.get_category_ids.forEach { (data) in
            
            tempArr.append(data)
            
            
        }
        let dic = NSDictionary(dictionary: ["category_name" : "All Categories","id":"0"])
        tempArr.insert(dic, at: 0)
        
        
        AllSelected()
        
        
    }
    
    func AllSelected(){
        
        if SelectedArray.isEmpty {
            
            tempArr.forEach { (data) in
                
                if let dic = data as? NSDictionary {
                    
                    
                    SelectedArray.append("\(dic.value(forKey: "id") ?? "")")
                    
                    
                }
                
                
            }
            
            
            isAllCatSelected = true
            filterTable.reloadData()
            
        }else{
            
            isAllCatSelected = false
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FilterTableViewCell = self.filterTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterTableViewCell
        
        //        cell.checkBox.tag = indexPath.row
        
        if let dic = tempArr[indexPath.row] as? NSDictionary {
            
            cell.categoryName.text = "\(dic.value(forKey: "category_name") ?? "")"
            
            if SelectedArray.contains("\(dic.value(forKey: "id") ?? "")") {
                cell.checkBoxImg.backgroundColor  =  UIColor(red: 43/255, green: 148/255, blue: 160/255, alpha: 1.0)
                
                
            }else{
                cell.checkBoxImg.backgroundColor  =   UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
                
            }
            
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0{
            
            if isAllCatSelected {
                
                isAllCatSelected = false
                SelectedArray.removeAll()
                tableView.reloadData()
                return
                
            }else{
                
                SelectedArray.removeAll()
                AllSelected()
                isAllCatSelected = true
                return
                
            }
            
            
        }else{
            isAllCatSelected = false
            if let index = SelectedArray.index(of: "0") {
                SelectedArray.remove(at: index)
                tableView.reloadData()
            }
            
        }
        
        if let dic = tempArr[indexPath.row] as? NSDictionary {
            
            if SelectedArray.contains("\(dic.value(forKey: "id") ?? "")") {
                
                
                if let index = SelectedArray.index(of: "\(dic.value(forKey: "id") ?? "")") {
                    
                    
                    SelectedArray.remove(at: index)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                }
                
            }else{
                SelectedArray.append("\(dic.value(forKey: "id") ?? "")")
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        checkIsAllCatSelected()
    }
    
    
    func checkIsAllCatSelected(){
        
        if SelectedArray.count == tempArr.count - 1 {
            
            SelectedArray.removeAll()
            AllSelected()
        }
        
    }
    
    
    // MARK: - BUTTON ACTIONS
    @IBAction func closeBtnAct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyBtnAct(_ sender: Any) {
        
        if isAllCatSelected{
            SelectedArray.removeAll()
        }
        delegate?.arrayList(selectedArray: SelectedArray)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkBoxBtnAct(_ sender: UIButton) {
        //        if sender.backgroundColor == UIColor(red: 43/255, green: 148/255, blue: 160/255, alpha: 1.0) {
        //            sender.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        //        }
        //        else {
        //            sender.backgroundColor = UIColor(red: 43/255, green: 148/255, blue: 160/255, alpha: 1.0)
        //        }
    }
    
}
