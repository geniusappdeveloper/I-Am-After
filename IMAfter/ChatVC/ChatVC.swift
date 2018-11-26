//
//  ChatVC.swift
//  IMAfter
//
//  Created by MAC on 2/1/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import JSQMessagesViewController
import MobileCoreServices
import AVKit
import GSImageViewerController
import SDWebImage
import GrowingTextView


class ChatVC: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var messages = [JSQMessage]();
    let picker = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetAllChat()
        picker.delegate = self;
        self.senderId = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
        self.senderDisplayName = "testing"
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "CameraOutlineDark"), for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.addTarget(self, action:#selector(newbutton), for: .touchUpInside)
        self.inputToolbar.contentView.leftBarButtonItemWidth = CGFloat(44)
        self.inputToolbar.contentView.leftBarButtonItem = button
        
        collectionView.backgroundColor = CONSTANT_COLOR
        
        let rightButton = UIButton(frame:CGRect(x: 0, y: 0, width: 0, height: 0 ))
        let sendImage = #imageLiteral(resourceName: "sendMsgWhite")
        rightButton.setImage(sendImage, for: .normal)
        self.inputToolbar.contentView.rightBarButtonItemWidth = CGFloat(44)
        self.inputToolbar.contentView.rightBarButtonItem = rightButton
        //        self.showLoadEarlierMessagesHeader = true
        
        
        //        if let contentView = self.inputToolbar.contentView {
        //            contentView.rightBarButtonItem.addSubview(button)
        //            contentView.rightBarButtonItemWidth = 90
        //            contentView.rightBarButtonItem.isUserInteractionEnabled = true
        //            contentView.rightBarButtonItem.isEnabled = true
        //            contentView.rightBarButtonItem.setImage(#imageLiteral(resourceName: "sendMsgWhite"), for: .normal)
        //            for constraint in contentView.leftBarButtonItem.superview!.constraints {
        //
        //                if (constraint.secondItem  as? UIButton) == contentView.leftBarButtonItem && constraint.firstAttribute == .leading {
        //                    constraint.isActive = false
        //                }
        //            }
        //
        //            contentView.rightBarButtonItem.snp.makeConstraints({ (make) in
        //                make.width.equalTo(60)
        //
        //            })
        //
        //            button.snp.makeConstraints({ (make) in
        //                make.top.equalTo(button.superview!.snp.top)
        //                make.bottom.equalTo(button.superview!.snp.bottom);
        //                make.leading.equalTo(0)
        //                make.width.equalTo(25);
        //            })
        //        }
        
        RemoveSenderAndReciverImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //remove if observer already added
        NotificationCenter.default.removeObserver(self, name: MESSAGECOME, object: nil)
        //New observer added
        NotificationCenter.default.addObserver(self, selector: #selector(NewMessage(notification:)), name: MESSAGECOME, object: nil)
    }
    
    func RemoveSenderAndReciverImage(){
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 0, height: 0)
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 0, height: 0)
        //  self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    override func viewWillLayoutSubviews()
    {
        
    }
    @objc func newbutton()
    {
        
        print("New button Taped")
        
    }
    
    
    //MARK:**************** Message Recived Through Notifications************
    @objc func NewMessage(notification: NSNotification){
        if let DetailsMessage = notification.userInfo as NSDictionary?{
            let message_type = "\(DetailsMessage.value(forKeyPath: "aps.alert.message_type") ?? "T")"
            print(DetailsMessage)
            if message_type == "I"{
                let Message = "\(DetailsMessage.value(forKeyPath: "aps.alert.msg") ?? "Deleted")"
                let SenderID = "\(DetailsMessage.value(forKeyPath: "aps.alert.friend_id") ?? "1")"
                let strDate = "\(DetailsMessage.value(forKeyPath: "aps.alert.msg_time") ?? "")"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date12 = dateFormatter.date(from: strDate) {
                    let photoItem = ChatAsyncPhoto(url: (URL(string: Message))!)
                    let message = JSQMessage(senderId: SenderID, senderDisplayName: Message, date: date12, media: photoItem)
                    self.messages.append(message!)
                }else{
                    let photoItem = ChatAsyncPhoto(url: (URL(string: Message))!)
                    let message = JSQMessage(senderId: SenderID, senderDisplayName: Message, date: Date(), media: photoItem)
                    self.messages.append(message!)
                }
            }else{
                let Message = "\(DetailsMessage.value(forKeyPath: "aps.alert.msg") ?? "Deleted")"
                let SenderID = "\(DetailsMessage.value(forKeyPath: "aps.alert.friend_id") ?? "1")"
                let strDate = "\(DetailsMessage.value(forKeyPath: "aps.alert.msg_time") ?? "")"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date12 = dateFormatter.date(from: strDate) {
                    self.messages.append(JSQMessage(senderId: SenderID, senderDisplayName: "Name", date: date12, text: Message))
                }else{
                    self.messages.append(JSQMessage(senderId: SenderID, senderDisplayName: "Name", date: Date(), text: Message))
                }
            }
            collectionView.reloadData()
            //To hadle Crash
            if messages.count > 4{
                collectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    
    
    //MARK: ************ JSQ DELEGATE AND DATASOURCE METHODS ************
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory();
        let message = messages[indexPath.item];
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.white);
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.white);
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messages[indexPath.item];
        if msg.isMediaMessage {
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL);
                let playerController = AVPlayerViewController();
                playerController.player = player;
                self.present(playerController, animated: true, completion: nil);
            }
            if let _ = msg.media as? JSQPhotoMediaItem {
                print(msg.senderDisplayName)
                if let image = SDImageCache.shared().imageFromMemoryCache(forKey: msg.senderDisplayName) {
                    let imageInfo      = GSImageInfo(image: image, imageMode: .aspectFit, imageHD: nil)
                    let transitionInfo = GSTransitionInfo(fromView: self.view)
                    let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                    present(imageViewer, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    
    //MARK: ScrollToBotton --------
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
           
//            let indexPath = IndexPath(row: self.messages.count, section: 0)
//            print(indexPath)
//            if indexPath[1] == 0{
//
//            }else{
//            self.collectionView.scrollToItem(at: IndexPath(item: self.messages.count, section: 0), at: UICollectionViewScrollPosition.top , animated: true)
//           }
//        }
            
            if self.messages.count != 0 {
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: false)
            }
            else
            {
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let msg = messages[indexPath.item];
        if !msg.isMediaMessage{
            cell.textView.textColor = .black
        }
        
        var dateString = String()
        let myDate =  String(format:"%@",msg.date! as CVarArg)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,hh:mm a"
            var date = msg.date!
            if(dateFormatter.date(from: myDate) != nil)
            {
                date = dateFormatter.date(from: myDate)!
            }
            dateFormatter.dateFormat = "MMM dd,hh:mm a"
            
            if(dateFormatter.string(from: date) != "")
            {
                dateString = dateFormatter.string(from: date)
            }
            else
            {
                dateString = " "
            }
        cell.cellBottomLabel.font = UIFont.boldSystemFont(ofSize: 9.0)
        cell.cellBottomLabel.textColor = UIColor.lightGray
        cell.cellBottomLabel.text = dateString
        return cell
    }
    
    // END COLLECTION VIEW FUNCTIONS
    // SENDING BUTTONS FUNCTIONS
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
            messages.append(JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text:text))
            collectionView.reloadData()
            if let data = SingletonClass.sharedInstance.ChatData{
                
                var localTimeZoneName: String { return TimeZone.current.identifier }

                let prams :[String:String] = [
                    "user_id":"\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                    "friend_id":data.friendID,
                    "msg_type":"T",
                    "msg":text,
                    "post_id":data.PostID,
                    "timeZone":localTimeZoneName
                    ]
                
                sendMessage(prams: prams)
            }
            // this will remove the text from the text field
            finishSendingMessage();
    }

    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "Media Messages", message: "Please Select A Media", preferredStyle: .actionSheet);
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        
        let photos = UIAlertAction(title: "Photos", style: .default,    handler: { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage);
        })
        
        let videos = UIAlertAction(title: "Camera", style: .default,    handler: { (alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie);
        })
        
        alert.addAction(photos);
        alert.addAction(videos);
        alert.addAction(cancel);
        present(alert, animated: true, completion: nil);
        
    }
    
    // END SENDING BUTTONS FUNCTIONS
    
    // PICKER VIEW FUNCTIONS
    
    private func chooseMedia(type: CFString) {
        //  picker.mediaTypes = [type as String]
        
        if type == kUTTypeMovie
        {
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
            
        }
        present(picker, animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let img = JSQPhotoMediaItem(image:pic)
            
            messages.append(JSQMessage(senderId: senderId, displayName: "test", media: img))
            
            
            // user_id,friend_id,msg_type(T/I),msg,post_id
            //            "user_id":"\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
            //            "friend_id":data.friendID,
            //            "post_id":data.PostID,
            //            "page":"1"
            
            
            if let data = SingletonClass.sharedInstance.ChatData{
                let headers =
                    [
                        "content-type": "application/json",
                        ]
                var localTimeZoneName: String { return TimeZone.current.identifier }
                
                let prams :[String:String] = [
                    "user_id":"\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                    "friend_id":data.friendID,
                    "msg_type":"I",
                    "post_id":data.PostID,
                    "timeZone":localTimeZoneName
                    ]
                
                uploadImage(urlString: API_BASE_URL + SEND_MESSAGE, headers: headers, params: prams, image: pic)
            }
            
            
        } else if let vid = info[UIImagePickerControllerMediaURL] as? URL  {
            
            let video  = JSQVideoMediaItem(fileURL: vid, isReadyToPlay: true)
            
            messages.append(JSQMessage(senderId: "1", displayName: "test", media: video))
            
            let filePath: URL = vid
            
            
            do {
                let asset = AVURLAsset(url: filePath , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                
                
                print(thumbnail)
                // thumbnail here
                
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
            
        }
        
        self.dismiss(animated: true, completion: nil);
        collectionView.reloadData();
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat
    {
        
        
        return 20.0
    }
    override  func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        let message: JSQMessage = self.messages[indexPath.item]
        
        return  JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        
    }
    // END PICKER VIEW FUNCTIONS
    
    // DELEGATION FUNCTIONS
    
    func messageReceived(senderID: String, senderName: String, text: String) {
        
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text));
        collectionView.reloadData()
        
    }
    
    func mediaReceived(senderID: String, senderName: String, url: String) {
        
        self.collectionView.reloadData();
        
        
    }
    
    
    
    
    
    
    //MAR:=========== API METHODS ===============

    //MARK:**************** Send Text Message Api  ************

    func sendMessage(prams:[String:String]){
        
        webservicesPostRequest(baseString: API_BASE_URL + SEND_MESSAGE, parameters: prams, success: { (response) in
            
            print(response)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    
    //MARK:**************** Get All Chat ************
    func GetAllChat(){
        
        if let data = SingletonClass.sharedInstance.ChatData{
            //  user_id,friend_id,post_id,page
            
            SingletonClass.sharedInstance.CurrentChatUser = data.friendID
            
            var localTimeZoneName: String { return TimeZone.current.identifier }
            
            let prams :[String:String] = [
                
                "user_id":"\(UserDefaults.standard.value(forKey: "user_id") ?? "")",
                "friend_id":data.friendID,
                "post_id":data.PostID,
                "page":"1",
                "timeZone":localTimeZoneName
            ]
            
            webservicesPostRequest(baseString: API_BASE_URL + GET_CHAT, parameters: prams, success: { (response) in
                
                print(response)
                
                let status =  "\(response.value(forKey: "status") ?? "0")"
                if status == "0"{
                    
                    return
                }
                
                if  let ChatData :NSArray = response.value(forKey: "result") as? NSArray {
                    
                    
                    self.messages.removeAll()
                    ChatData.forEach({ (chats) in
                        
                        
                        
                        let DetailsMessage = chats as! NSDictionary
                        
                        
                        let message_type = "\(DetailsMessage.value(forKey: "msg_type") ?? "T")"
                        
                        if message_type == "I"{
                            let Message = "\(DetailsMessage.value(forKey: "msg") ?? "Deleted")"
                            let SenderID = "\(DetailsMessage.value(forKey: "user_id") ?? "1")"
                            let strDate = "\(DetailsMessage.value(forKey: "msg_time") ?? "")"
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            if let date12 = dateFormatter.date(from: strDate) {
                                
                                let photoItem = ChatAsyncPhoto(url: (URL(string: Message))!)
                                let message = JSQMessage(senderId: SenderID, senderDisplayName: Message, date: date12, media: photoItem)
                                self.messages.append(message!)
                                
                            }else{
                                let photoItem = ChatAsyncPhoto(url: (URL(string: Message))!)
                                let message = JSQMessage(senderId: SenderID, senderDisplayName: Message, date: Date(), media: photoItem)
                                self.messages.append(message!)
                            }
                            
                        }else{
                            
                            
                            let Message = "\(DetailsMessage.value(forKey: "msg") ?? "Deleted")"
                            let SenderID = "\(DetailsMessage.value(forKey: "user_id") ?? "1")"
                            let strDate = "\(DetailsMessage.value(forKey: "msg_time") ?? "")"
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            if let date12 = dateFormatter.date(from: strDate) {
                                //      let timeInString = JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: date12)
                                
                                //     print(timeInString as a)
                                
                                self.messages.append(JSQMessage(senderId: SenderID, senderDisplayName: "Name", date: date12, text: Message))
                                
                            }else{
                                self.messages.append(JSQMessage(senderId: SenderID, senderDisplayName: "Name", date: Date(), text: Message))
                            }
                        }
                        
                        
                        
                        
                        
                    })
                    
                    // self.messages.reverse()
                    self.collectionView.reloadData()
                    self.scrollToBottom()
                }
                
                
                
                
                
                
                
                
            }, failure: { (error) in
                print(error)
                self.alert(title: "Error", message: error.localizedDescription)
            })
            
        }
        
        
        
    }
    
    //MARK:============= SEND IMAGE Image Message  =========================
    func uploadImage(urlString:String,headers:[String:String]?,params:[String:String]?,image:UIImage?){
        let boundary: String = "------VohpleBoundary4QuqLuM1cE5lMwCy"
        let contentType: String = "multipart/form-data; boundary=\(boundary)"
        
        var request = URLRequest(url: URL(string: urlString)!)
        if let tHeaders = headers {
            for (key, value) in tHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 60
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        //which field you have to sent image on server
        let fileName: String = "msg"
        if image != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(UIImageJPEGRepresentation(image!, 0.2)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                self.hideProgress()
                
                if(error != nil){
                    //  print(String(data: data!, encoding: .utf8) ?? "No response from server")
                    self.alert(title: "Alert", message: error?.localizedDescription ?? "Un-able to upload image please check your internet connection")
                }
                
                
                if let responseData = data{
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        print(json)
                        let dicData = json as! NSDictionary
                        let status = "\(dicData.value(forKey: "status") ?? "Error")"
                        
                        if status == "1"{
                            
                            
                            
                        }
                        
                        
                        
                    }catch let err{
                        print(err)
                        self.alert(title: "Alert", message: err.localizedDescription)
                        
                        
                    }
                }
                
            }
            
        }
        task.resume()
    }
    
    
    
    
}
