//
//  HomeViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 14/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    
    var catchUuid: String?
    
    var identityFlag: Int?
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    @IBOutlet weak var careTakerButton: UIButton!
    @IBOutlet weak var medicineUserButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiDesign()
        
        //clear all the requests in the notification center
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPillTakerPairView" {
            
        if let pillTakerPairVC = segue.destination as? PillTakerPairViewController {
                pillTakerPairVC.delegate = self
            }
        }
    }
    
    @IBAction func medicineUserButtonTapped(_ sender: Any) {
        createAlertForMedicineUser(title: "Medicine user chose", message:  "The identy will not be able to change after confirmation.")
    }
    @IBAction func careTakerButtonTapped(_ sender: Any) {
        createAlertForCareTaker(title: "Care taker chose", message: "The identy will not be able to change after confirmation.")
    
    }
    func uiDesign() {
    
        
        
        careTakerButton.layer.borderWidth = 1.5
        careTakerButton.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.8).cgColor
        
        careTakerButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        careTakerButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        careTakerButton.layer.shadowOpacity = 1.0
        careTakerButton.layer.shadowRadius = 10.0
        careTakerButton.layer.masksToBounds = false
        
        //======
        medicineUserButton.layer.borderWidth = 1.5
        medicineUserButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        
        medicineUserButton.layer.shadowColor = UIColor(red: 104/255.0, green: 104/255.0, blue: 104/255.0, alpha: 0.25).cgColor
        medicineUserButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        medicineUserButton.layer.shadowOpacity = 1.0
        medicineUserButton.layer.shadowRadius = 10.0
        medicineUserButton.layer.masksToBounds = false
    
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)
        
    }
    
    
    func createAlertForMedicineUser(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))

        
        newAlert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "toPillTakerPairView", sender: self)
        }))
        
        
        self.present(newAlert, animated: true, completion: nil)
        
    }

    func createAlertForCareTaker(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        
        newAlert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "toCareTakerView", sender: self)
        }))
        
        
        self.present(newAlert, animated: true, completion: nil)
        
    }

    
}

extension HomeViewController: PillTakerPairProtocol {

    func presentPTHomeVC() {
        performSegue(withIdentifier: "toPTHomeView", sender: nil)
    }

}
