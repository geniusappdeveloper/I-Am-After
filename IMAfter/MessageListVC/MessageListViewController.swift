//
//  MessageListViewController.swift
//  IMAfter
//
//  Created by SIERRA on 11/24/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit
import SDWebImage
class MessageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cell = MessageListTableViewCell()
   
    var OpenArray = [PostData]()
    var ClosedArray = [PostData]()
    // MARK: - OUTLETS
   
    
    @IBOutlet weak var msgListTable: UITableView!
    @IBOutlet weak var msgViewImage: UIImageView!
    
    // MARK: - VARIABLES
    var MsgListItems = [
        ["Image" : "fashion", "UsrName" : "Carol", "OfrName" : "SELLING: 70s flowery dress", "Time" : "13:21", "Msg" : "Hie, How are you. Hie, How are you. Hie, How are you. Hie, How are you. Hie, How are you. Hie, How are you. Hie, How are you."],
        ["Image" : "fashion", "UsrName" : "Alan", "OfrName" : "BUYING: Orange canoe", "Time" : "Yesterday", "Msg" : "Hie, How are you."],
        ["Image" : "fashion", "UsrName" : "Tory", "OfrName" : "BUYING: Tuning fork", "Time" : "3 Days Ago", "Msg" : "Hie, How are you. Hie, How are you. Hie, How are you. Hie, How are you. Hie, How are you."]
    ]
    
    var sectionTitle = ["Open", "Closed"]
    
    // MARK: - VIEW INIT METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgress()
        initView()
       
        self.msgListTable.estimatedRowHeight = 100
        self.msgListTable.rowHeight = UITableViewAutomaticDimension

        NotificationCenter.default.removeObserver(self, name: UPDATE_MY_MESSAGESCREEN, object: nil)
        //New observer added
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateData), name: UPDATE_MY_MESSAGESCREEN, object: nil)
        
        // Do any additional setup after loading the view.
    }

    @objc func UpdateData(){
        
        self.getMessageList()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        Device_Token_Api()
        
        tabBarController?.tabBar.isHidden = false
        initView()
    }
    
    func initView(){
        
        getMessageList()
        
        
    }
    
    // MARK: - TABLEVIEW DELEGATES
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 58)
        headerView.backgroundColor = UIColor(red:248/255, green:248/255, blue:248/255, alpha:1) //UIColor(red:243/255, green:243/255, blue:243/255, alpha:1)
        
        let lbl1 = UILabel()
        lbl1.frame = CGRect(x: headerView.frame.origin.x + 22, y: headerView.frame.origin.y+26, width: headerView.frame.size.width - 44, height: 31)
        lbl1.backgroundColor = UIColor.clear
        lbl1.text = sectionTitle[section]
        lbl1.textColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1)
        lbl1.font = lbl1.font.withSize(26)
        headerView.addSubview(lbl1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if verifyUrl(urlString: OpenArray[indexPath.row].LastMessage){

                return 200
                
            }else{
                
                return UITableViewAutomaticDimension

                
            }
            
        }else{
            
            if verifyUrl(urlString: ClosedArray[indexPath.row].LastMessage){
                
                return 200
                
            }else{
                
                return UITableViewAutomaticDimension
                
                
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
         
            return OpenArray.count
        }
         return ClosedArray.count
    }
    
//    private func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell : MessageListTableViewCell = msgListTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageListTableViewCell
//
//        RoundSpecificCorners(view: cell.msgBackView)
//
//        return cell
//    }
    func verifyUrl (urlString: String) -> Bool {
        //Check for nil
        if urlString.isStringLink(){
            
            return true
        }
        
        return false
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        

        
        if indexPath.section == 0 {
            
            if verifyUrl(urlString: OpenArray[indexPath.row].LastMessage){
                
                let cell : MessageListTableViewCell = msgListTable.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as! MessageListTableViewCell
                RoundLeftCorners(view: cell.msgBackView)

                cell.userImg.sd_setImage(with: URL(string:OpenArray[indexPath.row].friendPic))
                cell.userName.text = OpenArray[indexPath.row].Name
                cell.offerName.text = OpenArray[indexPath.row].PostName
                cell.chatTime.text = OpenArray[indexPath.row].Time
                cell.msgCount.text = OpenArray[indexPath.row].messageCount
                cell.msgCount.isHidden = OpenArray[indexPath.row].messageCount == "0" ?  true : false
                
                cell.msgImageView.setImage(url: OpenArray[indexPath.row].LastMessage)
                
                return cell
                
            }else{
                
            let cell : MessageListTableViewCell = msgListTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageListTableViewCell
                RoundLeftCorners(view: cell.msgBackView)

            cell.userImg.sd_setImage(with: URL(string:OpenArray[indexPath.row].friendPic))
            cell.userName.text = OpenArray[indexPath.row].Name
            cell.offerName.text = OpenArray[indexPath.row].PostName
            cell.chatTime.text = OpenArray[indexPath.row].Time
            cell.chatMsg.text = OpenArray[indexPath.row].LastMessage
            cell.msgCount.text = OpenArray[indexPath.row].messageCount
            cell.msgCount.isHidden = OpenArray[indexPath.row].messageCount == "0" ?  true : false
                return cell
            }
        }else{
            
            if verifyUrl(urlString: OpenArray[indexPath.row].LastMessage){
                let cell : MessageListTableViewCell = msgListTable.dequeueReusableCell(withIdentifier: "imagecell", for: indexPath) as! MessageListTableViewCell
            cell.userImg.sd_setImage(with: URL(string:ClosedArray[indexPath.row].friendPic))
            cell.userName.text = ClosedArray[indexPath.row].Name
            cell.offerName.text = ClosedArray[indexPath.row].PostName
            cell.chatTime.text = ClosedArray[indexPath.row].Time
            cell.msgCount.text = ClosedArray[indexPath.row].messageCount
            cell.msgCount.isHidden = ClosedArray[indexPath.row].messageCount == "0" ?  true : false
            cell.msgImageView.setImage(url: ClosedArray[indexPath.row].LastMessage)
                RoundLeftCorners(view: cell.msgBackView)

            return cell
            }else{
                
                let cell : MessageListTableViewCell = msgListTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageListTableViewCell
                RoundLeftCorners(view: cell.msgBackView)

                cell.userImg.sd_setImage(with: URL(string:ClosedArray[indexPath.row].friendPic))
                cell.userName.text = ClosedArray[indexPath.row].Name
                cell.offerName.text = ClosedArray[indexPath.row].PostName
                cell.chatTime.text = ClosedArray[indexPath.row].Time
                cell.chatMsg.text = ClosedArray[indexPath.row].LastMessage
                cell.msgCount.text = ClosedArray[indexPath.row].messageCount
                cell.msgCount.isHidden = ClosedArray[indexPath.row].messageCount == "0" ?  true : false
                return cell
            }
        }
        
        
//      self.msgListTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        if indexPath.section == 0 {
            vc.PostData = OpenArray[indexPath.row]
            SingletonClass.sharedInstance.ChatData = OpenArray[indexPath.row]
        }else{
            vc.PostData = ClosedArray[indexPath.row]
            SingletonClass.sharedInstance.ChatData = ClosedArray[indexPath.row]


        }
        navigationController?.pushViewController(vc, animated: true)
    }

    //MARK:================ GET LIST =====================
    //MAnvir 1feb18
    
    func getMessageList(){
        
        var localTimeZoneName: String { return TimeZone.current.identifier }

        let prams :[String:String] = [
            "user_id":"\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
            "timeZone":localTimeZoneName
        ]
        print(prams)
        webservicesPostRequest(baseString: API_BASE_URL + GET_MESSAGES_LIST, parameters: prams, success: { (response) in
         self.hideProgress()
            
            print(response)
            
            if let data :NSArray =  response.value(forKeyPath: "result") as? NSArray {
                
                self.OpenArray.removeAll()
                self.ClosedArray.removeAll()
                data.forEach({ (details) in
                    
                    print(details)
                     let Dict = details as? NSDictionary
                    
                    if "\(Dict?.value(forKeyPath: "post_status") ?? "0")" == "1"{
                     
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let Days = self.daysBetweenDates(endDate: formatter.date(from: "\(Dict?.value(forKeyPath: "chat_time") ?? "\(Date())")")!)
                        var ConvertedDate = ""
                        if Days == 0 {
                         
                            let DateFromBackend = formatter.date(from: "\(Dict?.value(forKeyPath: "chat_time") ?? "\(Date())")")
                            formatter.dateFormat = "HH:mm"
                            ConvertedDate = formatter.string(from: DateFromBackend ?? Date())

                        }else{
                            ConvertedDate = "\(Days) " + "days ago"
                            ConvertedDate = String(ConvertedDate.dropFirst())
                        }
                        
                        self.OpenArray.append(PostData(
                            Name: "\(Dict?.value(forKeyPath: "friend_name") ?? "NA")",
                            PostName: "\(Dict?.value(forKeyPath: "post_name") ?? "NA")",
                            Time: ConvertedDate,
                            LastMessage: "\(Dict?.value(forKeyPath: "last_msg") ?? "NA")",
                            friendPic: "\(Dict?.value(forKeyPath: "friend_pic") ?? "NA")",
                            PostID: "\(Dict?.value(forKeyPath: "post_id") ?? "NA")",
                            friendID: "\(Dict?.value(forKeyPath: "friend_id") ?? "NA")",
                            messageCount: "\(Dict?.value(forKeyPath: "unreadmsg_count") ?? "NA")"))
                        
                    }else{
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        print(Dict as Any)
                        let Days = self.daysBetweenDates(endDate: formatter.date(from: "\(Dict?.value(forKey: "chat_time") ?? "\(Date())")")!)
                        var ConvertedDate = ""
                        if Days == 0 {
                            
                            let DateFromBackend = formatter.date(from: "\(Dict?.value(forKeyPath: "chat_time") ?? "\(Date())")")
                            formatter.dateFormat = "HH:mm"
                            ConvertedDate = formatter.string(from: DateFromBackend ?? Date())
                            
                        }else{
                            ConvertedDate = "\(Days) " + "days ago"
                            ConvertedDate = String(ConvertedDate.dropFirst())
                        }
                        
                        
                        self.ClosedArray.append(PostData(Name: "\(Dict?.value(forKeyPath: "friend_name") ?? "NA")", PostName: "\(Dict?.value(forKeyPath: "post_name") ?? "NA")", Time: ConvertedDate, LastMessage: "\(Dict?.value(forKeyPath: "last_msg") ?? "NA")", friendPic: "\(Dict?.value(forKeyPath: "friend_pic") ?? "NA")", PostID: "\(Dict?.value(forKeyPath: "post_id") ?? "NA")", friendID: "\(Dict?.value(forKeyPath: "friend_id") ?? "NA")", messageCount: "\(Dict?.value(forKeyPath: "unreadmsg_count") ?? "NA")"))
                        
                    }
                    
            
                })
                
                self.msgListTable.reloadData()
            }
            
            
        }) { (error) in
            self.hideProgress()
            print(error.localizedDescription)
            self.alert(title: "Error", message: error.localizedDescription)
        }
        
    }
  
    //MARK: Device_Token_API
    func Device_Token_Api() {
        
        var localTimeZoneName: String { return TimeZone.current.identifier }
        
        
        if UserDefaults.standard.value(forKey: "DEVICETOKEN") as? String == nil
        {
            print("devicetoken is nil")
        }else
        {
            
            let params = ["user_id": "\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                "device_id": "\(UserDefaults.standard.value(forKey: "DEVICETOKEN") ?? "")",
                "device_type": "I",
                "timezone" :localTimeZoneName
            ]
            WebService.webService.device_token_Api(vc: self, params: params as NSDictionary){ _ in
                
            }
        }
    }
    
    //count days Ago
    func daysBetweenDates( endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: Date(), to: endDate)
        return components.day ?? 1
    }
    
    
}

extension String {
    func isStringLink() -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && self.characters.count > 0) else { return false }
        if detector!.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) > 0 {
            return true
        }
        return false
    }
}
