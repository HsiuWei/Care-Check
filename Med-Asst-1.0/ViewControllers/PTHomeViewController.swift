//
//  PTHomeViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 14/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit
import Firebase

import MessageUI

import UserNotifications

class PTHomeViewController: UIViewController {
    
    @IBOutlet weak var uuidDisplayLabel: UILabel!
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    @IBOutlet weak var changeWakingButtonView: UIButton!
    @IBOutlet weak var sendButtonView: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiDesign()
        
        uuidDisplayLabel.text = User.current.uuid
        
        
    }
    
        
    
    @IBAction func unwindFromChangeWakingTime(_ segue: UIStoryboardSegue) {
        
    }
    
    

    @IBAction func sendCodeButtonTapped(_ sender: Any) {
        
        if MFMessageComposeViewController.canSendText() {
            
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = self
            
            controller.body = User.current.uuid
            
            //controller.recipients = ["+886912597299"]
            self.present(controller, animated: true, completion: nil)
            
            
            
        }
        else {
            
            print("error happened for sending message")
            
        }

    }
    
    
    
    func uiDesign() {
        
                       
        changeWakingButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        changeWakingButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        changeWakingButtonView.layer.shadowOpacity = 0.8
        changeWakingButtonView.layer.shadowRadius = 10.0
        changeWakingButtonView.layer.masksToBounds = false
        
        sendButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sendButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
                    sendButtonView.layer.shadowOpacity = 0.8
        sendButtonView.layer.shadowRadius = 10.0
        sendButtonView.layer.masksToBounds = false
        
        HomeBackgroundView.clipsToBounds = true
        HomeBackgroundView.isHidden = false
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)



    }
    
    @IBAction func unwindToSettingHome(_ segue: UIStoryboardSegue) {
    }

    func createAlert(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }


    

    
}


extension PTHomeViewController: MFMessageComposeViewControllerDelegate {
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    
    
}

