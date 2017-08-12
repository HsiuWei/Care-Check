//
//  AddPairViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 23/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//


import UIKit
import Firebase

class AddPairViewController: UIViewController {
    
    var uuidEntered: String?
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    @IBOutlet weak var enteredUuidTextField: UITextField!
    @IBOutlet weak var nextButtonView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiDesign()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddPairViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func addPairNextButtonTapped(_ sender: Any) {
        
        guard enteredUuidTextField.text != "" else {
            createAlert(title: "Please complete filling required information", message: "")
            return
        }
        
        uuidEntered = enteredUuidTextField.text
        
    Database.database().reference().child("Users").child(uuidEntered!).observeSingleEvent(of: .value, with: { (returnedSnapshot) in
            
            if let _ = returnedSnapshot.value as? NSDictionary as? [String:[String: Any]] {
                
                print("yup you're good")
                
                Medicine.careTakerUuidArray.append(self.uuidEntered!)
                
                //set the value for the uuidCT in enum which has the key of UDkeys.uuidCT.keyCT
                UserDefaults.standard.set(Medicine.careTakerUuidArray, forKey: UDkeys.careTakerUuid.careTakerUuidkey)
                
                self.performSegue(withIdentifier: "toAddPatientNameView",sender: self.self)
                
            }
            else {
                print("No such uuid found")
                self.createAlert(title: "Please enter a pair code", message: "")
                return
            }
        })
        
    }
    
        
    func uiDesign() {
    
        
        nextButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        nextButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        nextButtonView.layer.shadowOpacity = 0.8
        nextButtonView.layer.shadowRadius = 10.0
        nextButtonView.layer.masksToBounds = false
        
        HomeBackgroundView.clipsToBounds = true
        HomeBackgroundView.isHidden = false
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)

            
        
        
    }
    
    @IBAction func unwindToAddPair(_ segue: UIStoryboardSegue) {
        
    }
    
    func createAlert(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }



}

