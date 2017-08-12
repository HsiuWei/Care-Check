//
//  MedListViewCellController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 18/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import  UIKit

protocol MedListViewCellProtocol: class {

    //tell the delegate to send the indexPath to the button action
    func presentSegue(with row: Int)
    func deleteMed(at row: Int)

}

class MedListViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    
    @IBOutlet weak var okSign: UIImageView!
    
    @IBOutlet weak var warningSign: UIImageView!
    
    //carch the row number from the MedListViewCellController
    var catchRow: Int!
    
    weak var delegate: MedListViewCellProtocol?
    

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
    
    //!!!!!!!Use protocol!!!!!!!!
    //reason: the "button" in the cell has "no connection" to the "indexPath.row number", so we want to make them "have connection"
    @IBAction func changeButtonTapped(_ sender: Any) {
        
        //send the row number that is tapped to the delagate
        delegate?.presentSegue(with: catchRow)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
    
        delegate?.deleteMed(at: catchRow)
    
    }
}
