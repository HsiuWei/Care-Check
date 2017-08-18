//
//  PillTakerPairViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 14/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseDatabase

import MessageUI

//3
//Only classes can use this protocol
protocol PillTakerPairProtocol: class {
    func presentPTHomeVC()
}

class PillTakerPairViewController: UIViewController {
    
    var longUuid: NSString?
    var uuid: NSString?
    var uuidString: String?
    
    @IBOutlet weak var uuidLabel: UILabel!
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    
    
    @IBOutlet weak var sendToCareTakerButton: UIButton!

    @IBOutlet weak var continueButton: UIButton!
    
    
    
    weak var delegate: PillTakerPairProtocol?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiDesign()
        
        //1
        longUuid = UUID().uuidString as NSString
        uuid = shortenUuid(longUuid: longUuid!, len: 8)
        
        uuidString = uuid as String?
        uuidLabel.text = uuidString
        
        //Save the uuid to the app data
        UserDefaults.standard.set(uuid, forKey: UDkeys.uuid.key)
        
        
        UserDefaults.standard.set(7, forKey: UDkeys.userWakeTime.userWakeTimekey)
        UserDefaults.standard.set(10, forKey: UDkeys.userSleepTime.userSleepTimkey)
        
    }

    
    @IBAction func continueButtonTapped(_ sender: Any) {
        //2
        //make sure the paur scene will not show up again unless the user delete the app
        //dismiss this view controller(PillTakerPairViewController) using dismiss function
        //runt the closure input after dinish running the animated true(disapearing completed)
        
        self.dismiss(animated: true) { [weak self] in
            //closure completion will be called when dismiss completes
            //tell the home view controller to run the presentPThome func, since the segur is in the homeVC
            
            //tell the delegate to trigger the pthomevc & send the uuid (all defined in that function)
            self?.delegate?.presentPTHomeVC()
        }
        
    }
    
    func shortenUuid(longUuid: NSString, len: Int) -> NSString {
        
        let letters : NSString = longUuid
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 1...len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        
        if MFMessageComposeViewController.canSendText() {
        
            let controller = MFMessageComposeViewController()
            controller.messageComposeDelegate = self
            
            controller.body = uuidString!
        
            //controller.recipients = ["+886912597299"]
            self.present(controller, animated: true, completion: nil)
            
            
            
        }
        else {
            
            print("error happened for sending message")
        
        }
        
        
    }
    
    
    
    func uiDesign() {
                
        sendToCareTakerButton.layer.borderWidth = 1.1
        sendToCareTakerButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        
        sendToCareTakerButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sendToCareTakerButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        sendToCareTakerButton.layer.shadowOpacity = 0.8
        sendToCareTakerButton.layer.shadowRadius = 10.0
        sendToCareTakerButton.layer.masksToBounds = false
        
        continueButton.layer.borderWidth = 1.1
        continueButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        
        continueButton.layer.shadowColor = UIColor(red: 104/255.0, green: 104/255.0, blue: 104/255.0, alpha: 0.25).cgColor
        continueButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        continueButton.layer.shadowOpacity = 1.0
        continueButton.layer.shadowRadius = 10.0
        continueButton.layer.masksToBounds = false
        
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)

        
    }

    
    
}


extension PillTakerPairViewController: MFMessageComposeViewControllerDelegate {


    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        self.dismiss(animated: true, completion: nil)
        
    }


}
