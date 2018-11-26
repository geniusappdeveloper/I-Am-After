//
//  SavedTableViewCell.swift
//  IMAfter
//
//  Created by SIERRA on 11/28/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class SavedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var saved_collection: SectionCollectionView!
    
    @IBOutlet weak var tableSelectBtn: SectionButton!
    @IBOutlet weak var viewMsgsBtn: SectionButton!
    @IBOutlet weak var offerToSellView: DesignableView!
    @IBOutlet weak var collectionBackView: UIView!
    @IBOutlet weak var collectionBackView_ht: NSLayoutConstraint!
    
    @IBOutlet var category_Nam: UILabel!
    
    @IBOutlet var post_Nam: UILabel!
    
    @IBOutlet var unanswered_Msg: DesignableLable!
    
    @IBOutlet var tablePost_Img: DesignableImage!
    
    @IBOutlet var tablePostImg_Day: UILabel!
    
    @IBOutlet var tablePost_price: UILabel!
    
    @IBOutlet var offerToCellBtn_out: SectionButton!
    
    @IBOutlet var btnDeletePost: SectionButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollection <D: UICollectionViewDelegate & UICollectionViewDataSource> (dataSourceDelegate: D, forRow row: Int) {
        
        saved_collection.delegate = dataSourceDelegate
        saved_collection.dataSource = dataSourceDelegate
        saved_collection.tag = row
        saved_collection.reloadData()
        saved_collection.collectionViewLayout.invalidateLayout()
    }

}
