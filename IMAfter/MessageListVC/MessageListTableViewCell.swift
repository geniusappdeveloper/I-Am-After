//
//  MessageListTableViewCell.swift
//  IMAfter
//
//  Created by SIERRA on 11/24/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class MessageListTableViewCell: UITableViewCell {

    @IBOutlet var userImg: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var offerName: UILabel!
    @IBOutlet var chatTime: UILabel!
    @IBOutlet var chatMsg: UILabel!
    @IBOutlet var msgBackView: UIView!
    @IBOutlet weak var msgImageView: UIImageView!
    @IBOutlet  var msgCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        userImg.layer.cornerRadius = userImg.frame.size.width/2
//        userImg.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = msgBackView.frame
//        rectShape.position = msgBackView.center
//        rectShape.path = UIBezierPath(roundedRect: msgBackView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topRight], cornerRadii: CGSize(width: 7, height: 7)).cgPath
//        msgBackView.layer.mask = rectShape
        
//        userImg.layer.cornerRadius = userImg.frame.size.height/2
//        userImg.clipsToBounds = true
    }

}
