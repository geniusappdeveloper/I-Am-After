//
//  PostAmountTableViewCell.swift
//  IMAfter
//
//  Created by SIERRA on 11/20/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class PostAmountTableViewCell: UITableViewCell {

    
//    @IBOutlet var selectableView: DesignableView!
    @IBOutlet var selectableImg: DesignableImage!
//    @IBOutlet var selectableBtn: UIButton!
    @IBOutlet var amountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
