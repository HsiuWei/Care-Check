//
//  AddNameViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 23/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit

class AddNameViewController: UIViewController {

    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    @IBOutlet weak var doneButtonView: UIButton!
    @IBOutlet weak var addNameTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        uiDesign()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNameViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToCTHomeFromAddName" {
        
        let ctHomeVC = segue.destination as! CTHomeVIewController
            ctHomeVC.switchNum = Medicine.patientNameArray.count - 1
        }
    }
    
    @IBAction func addNameDoneButtonPressed(_ sender: Any) {
        
        if addNameTextField.text != "" {
        
            Medicine.patientNameArray.append(addNameTextField.text!)
            UserDefaults.standard.set(Medicine.patientNameArray, forKey: UDkeys.patientName.patientNamekey)
            
            performSegue(withIdentifier: "unwindToCTHomeFromAddName", sender: self)
        }
        else {
            return
        }
        
    }
    

    
    func uiDesign() {
                
        
        doneButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        doneButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        doneButtonView.layer.shadowOpacity = 0.8
        doneButtonView.layer.shadowRadius = 10.0
        doneButtonView.layer.masksToBounds = false
        
        
        HomeBackgroundView.clipsToBounds = true
        HomeBackgroundView.isHidden = false
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)
    }
    
    @IBAction func unwindToAddName(_ segue: UIStoryboardSegue) {
        
    }
    

    
}
