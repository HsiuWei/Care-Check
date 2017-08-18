//
//  CareTakerPairViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 15/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CareTakerPairViewController: UIViewController {

    var uuidEntered: String?
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var uuidEnterTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //UserDefaults.standard.set(true, forKey: UDkeys.careTakerUsedFlag.careTakerUsedFlagkey)
        uiDesign()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CareTakerPairViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        guard uuidEnterTextField.text != "" else {
            
            createAlert(title: "Please complete filling required information", message: "")
            
            return
        }
        
        uuidEntered = uuidEnterTextField.text
        
        Database.database().reference().child("Users").child(uuidEntered!).observeSingleEvent(of: .value, with: { (returnedSnapshot) in
        
            if let _ = returnedSnapshot.value as? NSDictionary as? [String:[String: Any]] {
                
                               
                
                Medicine.careTakerUuidArray.append(self.uuidEntered!)
                
                UserDefaults.standard.set(Medicine.careTakerUuidArray, forKey: UDkeys.careTakerUuid.careTakerUuidkey)
                
    
                self.performSegue(withIdentifier: "toRelationView",sender: self.self)

            }
            else {
                print("No such uuid found")
                self.createAlert(title: "Please enter a valid pair code", message: "No such pair code found")
                return
            }
        })
       
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
    
    func createAlert(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "OK, I see", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }


    
    
}
