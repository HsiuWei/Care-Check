//
//  AddMedViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 15/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit

class AddMedViewController: UIViewController {

    var medName: String?
    var medNickname: String?
    
    @IBOutlet weak var nextButtonView: UIButton!
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    @IBOutlet weak var medNameTextField: UITextField!
    @IBOutlet weak var medNicknameTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiDesign()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMedViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        medNameTextField.becomeFirstResponder()
        
    }
    
    
    @IBAction func nextButtonAddTapped(_ sender: Any) {
        
        if medNameTextField.text != "" && medNicknameTextField.text != "" {
            performSegue(withIdentifier: "toPeriodMedView", sender: self)
        }
        else {
            createAlert(title: "Please complete the required information", message: "")
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPeriodMedView" {
        let newMed: Medicine!
        
        if medNameTextField.text != "" && medNicknameTextField.text != "" {
            newMed = Medicine(name: medNameTextField.text!, nickname: medNicknameTextField.text!)
            
            let periodVC = segue.destination as! PeriodMedViewController
            periodVC.catchNewMed = newMed
        }
        else {
            newMed = nil
            return
        }
        
        
        
        }
    }

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func createAlert(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }
    
   
    
    func uiDesign() {
        
                
        nextButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        nextButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        nextButtonView.layer.shadowOpacity = 0.8
        nextButtonView.layer.shadowRadius = 10.0
        nextButtonView.layer.masksToBounds = false
        
      
        HomeBackgroundView.clipsToBounds = true

        //HomeBackgroundView.isHidden = false
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)
    
    }
    
    @IBAction func unwindToAdd(_ segue: UIStoryboardSegue) {
    }

    
   

    
    
}

