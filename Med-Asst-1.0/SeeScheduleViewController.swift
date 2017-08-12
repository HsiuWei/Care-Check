//
//  SeeScheduleViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 11/08/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation
import UIKit

class SeeScheduleViewController: UIViewController {

    var catchIndexRow: Int?
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    @IBOutlet weak var scheduleTextField: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiDesign()
        
        if catchIndexRow != nil {
            
        
            //get today
            let today = Date()
            let calendar = Calendar.current
            let monthNow = calendar.component(.month, from: today)
            let dayNow = calendar.component(.day, from: today)
            let yearNow = calendar.component(.year, from: today)
            //let hourNow = calendar.component(.hour, from: today)
            //let minuteNow = calendar.component(.minute, from: today)
            
            var allText: String = ""
            for (_,value) in (User.current.medicineArray?[catchIndexRow!].notificationIDs)! {
                
                let dateString = value
                let dateStringArray = dateString.components(separatedBy: " ")
                
                //let time = dateStringArray[0]
                //let timeStringArray = time.components(separatedBy: ":")
                //let hour = Int(timeStringArray[0])
                //let minute = Int(timeStringArray[1])
                
                let date = dateStringArray[1]
                let montheDayYearStringArray = date.components(separatedBy: "/")
                let month = Int(montheDayYearStringArray[0])
                let day = Int(montheDayYearStringArray[1])
                let year = Int(montheDayYearStringArray[2])
                
                
                
                if month == monthNow && day! == dayNow && year! == yearNow {
                    
                    allText = allText + value + "\n"
                }
            }
            
            if allText == "" {
                
                scheduleTextField.text = "No upcoming schedule for today :)"
               
                
            }
            else {
                
                scheduleTextField.text = "Today's missing or upcoming schedule(s)" + "\n" + "\n" + allText
               
                
            }
            
            
        }
            
        else {
            print("the index path is nil")
        }
        
    }
    
    func uiDesign() {
        
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
