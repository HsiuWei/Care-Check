//
//  PTAgreementViewController.swift
//  Care Tracker
//
//  Created by Hsiu-Wei Chang on 19/08/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation
import UIKit

class PTAgreementViewController: UIViewController {
    
    @IBOutlet weak var agreeButtonView: UIButton!
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    func uiDesign() {
        
        
        agreeButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        agreeButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        agreeButtonView.layer.shadowOpacity = 0.8
        agreeButtonView.layer.shadowRadius = 10.0
        agreeButtonView.layer.masksToBounds = false
        
        HomeBackgroundView.clipsToBounds = true
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)
        
        
    }

    
}
