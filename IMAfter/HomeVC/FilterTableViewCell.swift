//
//  FilterTableViewCell.swift
//  IMAfter
//
//  Created by SIERRA on 11/17/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet var checkBoxImg: UIImageView!
//    @IBOutlet var checkBox: UIButton!
    @IBOutlet var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
