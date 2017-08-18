//
//  RelationViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 21/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation
import UIKit


class RelationViewController: UIViewController {

    var patientName: String?
    
    
    @IBOutlet weak var ptNameLabel: UITextField!
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiDesign()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RelationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //retrieve uuid from user defaults
       /* let ctUuidArray = UserDefaults.standard.stringArray(forKey: UDkeys.careTakerUuid.careTakerUuidkey) ?? [String]()
        ctUuidLabel.text = ctUuidArray[0]
 
         */
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navVC2 = segue.destination as! UINavigationController
        let cTHomeVC = navVC2.topViewController as! CTHomeVIewController
        cTHomeVC.catchPtName = patientName
        
        
        
    }
    
    @IBAction func relationNextButtonTapped(_ sender: Any) {
        
        if ptNameLabel.text != "" {
            patientName = ptNameLabel.text
            Medicine.patientNameArray.append(patientName!)
            UserDefaults.standard.set(Medicine.patientNameArray, forKey: UDkeys.patientName.patientNamekey)

            performSegue(withIdentifier: "toCTHomeView", sender: self)
        }
        else {
            return
        }
    }
    
    
    
    func uiDesign() {
        
        
        nextButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        nextButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        nextButton.layer.shadowOpacity = 0.8
        nextButton.layer.shadowRadius = 10.0
        nextButton.layer.masksToBounds = false
        
        HomeBackgroundView.clipsToBounds = true
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)

        
        
    }

    
    
}
