//
//  CTMedListViewCell.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 21/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import  UIKit

class CTMedListViewCell: UITableViewCell {


    @IBOutlet weak var medNameLabel: UILabel!

    @IBOutlet weak var medNicknameLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var warningSignView: UIImageView!
    @IBOutlet weak var okSignView: UIImageView!
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        contentView.backgroundColor = UIColor(red: 227/255.0, green: 239/255.0, blue: 241/255.0, alpha: 1.0)
        
        //for round corner look
        cardView.layer.cornerRadius = 3.0
        //for shadow
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
        
    }
    
        
    
}