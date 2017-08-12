//
//  ConfirnationViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 15/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import UserNotifications

class ConfirmationViewController: UIViewController {
    
    var catchMed: Medicine?
    
    @IBOutlet weak var nameConfirmLabel: UILabel!
    @IBOutlet weak var nicknameConfirmLabel: UILabel!
    @IBOutlet weak var fromConfirmLabel: UILabel!
    @IBOutlet weak var toConfirmLabel: UILabel!
    @IBOutlet weak var amountConfirmLabel: UILabel!
    @IBOutlet weak var periodConfirmLabel: UILabel!
    @IBOutlet weak var noteConfirmTextField: UITextView!
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    @IBOutlet weak var confirmButtonView: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        uiDesign()
        
        nameConfirmLabel.text = catchMed?.name
        nicknameConfirmLabel.text = catchMed?.nickname
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "MM/dd/yyyy"
        fromConfirmLabel.text = myFormatter.string(from: catchMed!.fromDate)
        toConfirmLabel.text = myFormatter.string(from: catchMed!.toDate)
        
        amountConfirmLabel.text = String(describing: catchMed!.amount!)
        periodConfirmLabel.text = String(describing: catchMed!.frequency!)
        
        noteConfirmTextField.text = catchMed?.unit
        
        
    }
    
    

    @IBAction func confirmationButtonTapped(_ sender: Any) {
        
        //clear all the requests
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        catchMed?.notificationIDs = [:]
        //create all the notifications
        //this function need completion handler
        ReminderHelperClass.scheduleNotification(for: catchMed!)
        
        let finalMedWithNotificationIDs = Medicine(name: (self.catchMed?.name)!, nickname: (self.catchMed?.nickname)!, fromDate: (self.catchMed?.fromDate)!, toDate: (self.catchMed?.toDate)!, amount: (self.catchMed?.amount)!, frequency: (self.catchMed?.frequency)!, unit: (self.catchMed?.unit)!, notificationIDs: (self.catchMed?.notificationIDs)!)
        
        
        UserMedService.putMedicine(put: finalMedWithNotificationIDs, atThisUuid: User.current.uuid, onCompletion: { (statusString) in
            
            if statusString == "Success" {
                self.performSegue(withIdentifier: "unwindToMedListVC", sender: self.self)
            }
                
            else {
                print("Failure")
            }
        })

        
    }
       
    func uiDesign() {
        
        
        self.confirmButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.confirmButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.confirmButtonView.layer.shadowOpacity = 0.8
        self.confirmButtonView.layer.shadowRadius = 10.0
        self.confirmButtonView.layer.masksToBounds = false
        
        HomeBackgroundView.clipsToBounds = true
        HomeBackgroundView.isHidden = false
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)
        
    }

}
