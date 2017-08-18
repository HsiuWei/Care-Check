//
//  CTHomeViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 21/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit
import Firebase

class CTHomeVIewController: UIViewController {

    var catchUuid: String?
    
    var catchPtName: String?
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    @IBOutlet weak var eyePictureView: UIImageView!
    
    @IBOutlet weak var switchPatientView: UIButton!
    @IBOutlet weak var addPatientButtonView: UIButton!
    @IBOutlet weak var seePtMedButton: UIButton!
    
    var switchNum: Int!
    
    var messageFlagInListVC: Bool?
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiDesign()
        
        if UserDefaults.standard.value(forKey: UDkeys.tutorialMessageFlag.tutorialMessageFlagkey) as! Bool == true {
            self.createAlert(title: "Welcome!", message: "Make sure Wifi is turned on to keep monitoring. Click \"Add\" to monitor additional medicine users. \nClick switch button to view another user or to delete users. \n Click the eye button to monitor the medicine they're taking.")
            messageFlagInListVC = true
        }

    
        if let historySwitchNum = UserDefaults.standard.value(forKey: UDkeys.switchPatientNumber.switchPatientNumberkey) as? Int {
            switchNum = historySwitchNum
            
            Medicine.careTakerUuidArray = UserDefaults.standard.stringArray(forKey: UDkeys.careTakerUuid.careTakerUuidkey)!
            
            let thisUser = User(uuid: Medicine.careTakerUuidArray[switchNum])
            //make this user a singleton user (current)
            User.setSingleton(thisUser)
        }
        
        else {
            switchNum = 0
            
             Medicine.careTakerUuidArray = UserDefaults.standard.stringArray(forKey: UDkeys.careTakerUuid.careTakerUuidkey)!
            
            let thisUser = User(uuid: Medicine.careTakerUuidArray[switchNum])
            //make this user a singleton user (current)
            User.setSingleton(thisUser)
        }

    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        if (UserDefaults.standard.stringArray(forKey: UDkeys.careTakerUuid.careTakerUuidkey) != nil) && (UserDefaults.standard.stringArray(forKey: UDkeys.patientName.patientNamekey) != nil) {
            
            Medicine.careTakerUuidArray =  UserDefaults.standard.stringArray(forKey: UDkeys.careTakerUuid.careTakerUuidkey)!
            Medicine.patientNameArray = UserDefaults.standard.stringArray(forKey: UDkeys.patientName.patientNamekey)!
            
        }
        
     //========
        if Medicine.patientNameArray == [] {
            seePtMedButton.isHidden = true
            eyePictureView.isHidden = true
        }
        else {
            seePtMedButton.isHidden = false
            
            seePtMedButton.titleLabel!.lineBreakMode = .byWordWrapping
            seePtMedButton.titleLabel!.textAlignment = .center
            
            if switchNum > (Medicine.patientNameArray.count - 1) {
                switchNum = switchNum - 1
                
                seePtMedButton.setTitle("See \(Medicine.patientNameArray[switchNum])'s Medicine", for: .normal)
            }
            
            else {
            
                seePtMedButton.setTitle("See \(Medicine.patientNameArray[switchNum])'s Medicine", for: .normal)
            
            }
            
            
            
            //store the switch num
            UserDefaults.standard.set(switchNum, forKey: UDkeys.switchPatientNumber.switchPatientNumberkey)
        }
        
    }
    
    @IBAction func unwindFromAddPatientNameToCTHomeVC(_ segue: UIStoryboardSegue) {
    
    }
    
    @IBAction func unwindFromSwitchCell(_ segue: UIStoryboardSegue) {
        
    }
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCTMedListView" {
            let cTMedListVC = segue.destination as! CTMedListViewController
            cTMedListVC.catchSwitchNum = switchNum
            cTMedListVC.catchPatientName = Medicine.patientNameArray[switchNum]
            
            if messageFlagInListVC != nil {
                cTMedListVC.messageFlag = true
                messageFlagInListVC = nil
            }
        }
    }
    
    @IBAction func seePatientMedButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toCTMedListView", sender: self)
    }
    
   
    
    func uiDesign() {
        
        seePtMedButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        seePtMedButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        seePtMedButton.layer.shadowOpacity = 0.8
        seePtMedButton.layer.shadowRadius = 10.0
        seePtMedButton.layer.masksToBounds = false
        
        addPatientButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addPatientButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        addPatientButtonView.layer.shadowOpacity = 0.8
        addPatientButtonView.layer.shadowRadius = 10.0
        addPatientButtonView.layer.masksToBounds = false
        
        switchPatientView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        switchPatientView.layer.shadowOffset = CGSize(width: 3, height: 3)
        switchPatientView.layer.shadowOpacity = 0.8
        switchPatientView.layer.shadowRadius = 10.0
        switchPatientView.layer.masksToBounds = false
        
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
        
        newAlert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }


    

}

