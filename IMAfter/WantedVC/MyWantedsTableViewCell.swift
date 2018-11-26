//
//  MyWantedsTableViewCell.swift
//  IMAfter
//
//  Created by SIERRA on 11/27/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import UIKit

class MyWantedsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myWanted_collection: SectionCollectionView!
    
    @IBOutlet weak var tableSelectBtn: SectionButton!
    @IBOutlet var closelistViewBtn_out: UIView!
    @IBOutlet var btnCloseListing: SectionButton!
    
    @IBOutlet var wantedCat_Nam: UILabel!
    
    @IBOutlet var wantedCatPost_Nam: UILabel!
    
    @IBOutlet var wantedNew_msgs: DesignableLable!
     @IBOutlet var wantedUnanswered_msgs: DesignableLable!
    
    @IBOutlet var wantedPost_Img: DesignableImage!
    
    @IBOutlet var wantedPost_Day: UILabel!
    
    
    @IBOutlet var wantedPost_Price: UILabel!
    
    @IBOutlet weak var collectionBackView: UIView!
    @IBOutlet weak var collectionBackView_ht: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCollection <D: UICollectionViewDelegate & UICollectionViewDataSource> (dataSourceDelegate: D, forRow row: Int) {
        
        myWanted_collection.delegate = dataSourceDelegate
        myWanted_collection.dataSource = dataSourceDelegate
        myWanted_collection.tag = row
        myWanted_collection.reloadData()
        myWanted_collection.collectionViewLayout.invalidateLayout()
    }
}
