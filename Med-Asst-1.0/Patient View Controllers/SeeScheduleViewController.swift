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
    @IBOutlet weak var upComingTextField: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scheduleTextField.isScrollEnabled = false
        
        uiDesign()
        
        if catchIndexRow != nil {
            
        
            //get today
            let today = Date()
            let calendar = Calendar.current
            let monthNow = calendar.component(.month, from: today)
            let dayNow = calendar.component(.day, from: today)
            let yearNow = calendar.component(.year, from: today)
            let hourNow = calendar.component(.hour, from: today)
            //let minuteNow = calendar.component(.minute, from: today)
            
            var missedDateText: String = ""
            var upcomingDateText: String = ""
            for (_,value) in (User.current.medicineArray?[catchIndexRow!].notificationIDs)! {
                
                var varValue = value
                
                let dateString = value
                let dateStringArray = dateString.components(separatedBy: " ")
                
                let time = dateStringArray[0]
                let timeStringArray = time.components(separatedBy: ":")
                let hour = Int(timeStringArray[0])
                let minute = Int(timeStringArray[1])
                
                let date = dateStringArray[1]
                let montheDayYearStringArray = date.components(separatedBy: "/")
                let month = Int(montheDayYearStringArray[0])
                let day = Int(montheDayYearStringArray[1])
                let year = Int(montheDayYearStringArray[2])

                var ampmString: String = ""
                if hour! > 12 {
                    
                    let hourForDisplay = hour! - 12
                    
                    ampmString = " PM"
                    
                    if hourForDisplay < 10 {
                        varValue = "0" + String(hourForDisplay) + ":" + String(describing: minute!) + ampmString
                    }
                    else {
                        varValue = String(hourForDisplay) + ":" + String(describing: minute!) + ampmString
                    }
                    
                    if minute! < 10 {
                    
                        varValue.insert("0", at: varValue.index(varValue.startIndex, offsetBy: 3))
                    
                    }
                }
                
                else {
                    ampmString = " AM"
                    
                    //fill with 0s if needed
                    if hour! < 10 {
                        varValue.insert("0", at: varValue.index(varValue.startIndex, offsetBy: 0))
                    }
                    
                    if minute! < 10 {
                        varValue.insert("0", at: varValue.index(varValue.startIndex, offsetBy: 3))
                    }
                    
                    //substract the date
                    varValue = varValue.substring(to: varValue.index(varValue.endIndex, offsetBy: -10)) + ampmString
                    
                }
                
                
                
                
                
                
                
                //put integers into type date
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = day
                dateComponents.hour = hour
                dateComponents.minute = minute
                
                // Create date from components
                var userCalendar = Calendar.current // user calendar
                var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
                userCalendar.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)!
                userCalendar.timeZone = TimeZone.current
                let theDateTime = userCalendar.date(from: dateComponents)
                
                if theDateTime! < Date() {
                    missedDateText = missedDateText + varValue + "\n"
                }
                
                else if (theDateTime! >= Date()) && year! == yearNow && month! == monthNow && day! == dayNow {
                    upcomingDateText = upcomingDateText + varValue + "\n"
                }
            }
            
            if missedDateText == "" && upcomingDateText == "" {
                
                scheduleTextField.textColor = UIColor.black
                scheduleTextField.text = "No missing taking medicines so far."
                scheduleTextField.isScrollEnabled = true
                upComingTextField.text = "No upcoming schedules today."
                upComingTextField.isScrollEnabled = true
                
            }
            else if missedDateText == "" && upcomingDateText != "" {
                
                scheduleTextField.textColor = UIColor.black
                scheduleTextField.text = "No missing taking medicines so far."
                scheduleTextField.isScrollEnabled = true
                upComingTextField.text = upcomingDateText
                upComingTextField.isScrollEnabled = true

                
            }
            
            else if missedDateText != "" && upcomingDateText == "" {
                
                scheduleTextField.text = missedDateText
                scheduleTextField.isScrollEnabled = true
                upComingTextField.text = "No upcoming schedules today."
                upComingTextField.isScrollEnabled = true

                
            }
            
            else if missedDateText != "" && upcomingDateText != "" {
                
                scheduleTextField.text = missedDateText
                scheduleTextField.isScrollEnabled = true
                upComingTextField.text = upcomingDateText
                upComingTextField.isScrollEnabled = true
                
            }
            
            
        }
            
        else {
            //"the index path is nil"
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
