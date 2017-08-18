//
//  SetWakingViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 28/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation
import UIKit

class SetWakingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    var wakeNum: Int!
    var sleepNum: Int!
   
    @IBOutlet weak var changeSettingButtonView: UIButton!
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    
    @IBOutlet weak var wakePicker: UIPickerView!
    @IBOutlet weak var sleepPicker: UIPickerView!
    
    @IBOutlet weak var wakeTimeLabel: UILabel!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    
    @IBOutlet weak var wakingPmAmLabel: UILabel!
    @IBOutlet weak var sleepingPmAmLabel: UILabel!
    
    @IBOutlet weak var wakingPickerPmAmLabel: UILabel!
    @IBOutlet weak var sleepingPickerPmAmLabel: UILabel!
    
    let hourNums = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        uiDesign()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wakeNum = UserDefaults.standard.value(forKey: UDkeys.userWakeTime.userWakeTimekey) as! Int
        sleepNum = UserDefaults.standard.value(forKey: UDkeys.userSleepTime.userSleepTimkey) as! Int
        
        print(" sleepNum = \( sleepNum)")
        
        wakeTimeLabel.text = String(wakeNum)
        sleepTimeLabel.text = String(sleepNum)
        
        if wakeNum == 12 {
            wakingPmAmLabel.text = ":00 PM"
            wakingPickerPmAmLabel.text = "PM"
        }
            
        else {
            wakingPmAmLabel.text = ":00 AM"
            wakingPickerPmAmLabel.text = "AM"
        }
        
        if sleepNum == 12 {
            sleepingPmAmLabel.text = ":00 AM"
            sleepingPickerPmAmLabel.text = "AM"
        }
        else {
            sleepingPmAmLabel.text = ":00 PM"
            sleepingPickerPmAmLabel.text = "PM"
        }
        
        wakePicker.selectRow(wakeNum - 1, inComponent: 0, animated: true)
        sleepPicker.selectRow(sleepNum - 1, inComponent: 0, animated: true)
        
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //1 row needed only
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hourNums[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hourNums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == wakePicker {
            
            wakeNum = Int(hourNums[row])!
            
            if wakeNum == 12 {
            
                wakingPickerPmAmLabel.text = "PM"
            
            }
            else {
                
                wakingPickerPmAmLabel.text = "AM"
            
            }
            
        }
        
        else {
            sleepNum = Int(hourNums[row])!
            if sleepNum == 12 {
                
                sleepingPickerPmAmLabel.text = "AM"
                
            }
            else {
                
                sleepingPickerPmAmLabel.text = "PM"
                
            }

            
        
        }
    }
    
    @IBAction func changeTimeButtonTappe(_ sender: Any) {
        
        UserDefaults.standard.set(wakeNum, forKey: UDkeys.userWakeTime.userWakeTimekey)
        UserDefaults.standard.set(sleepNum, forKey: UDkeys.userSleepTime.userSleepTimkey)
        
    }
    
    /*
    func transformTo24HourBase(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        //formatter.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "h:mm a"

        let str = dateFormatter.string(from: date)
        
        
        let date = dateFormatter.date(from: str)
        
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from: date!)
        //let date24 = formatter.date(from: str)
        
        let index = date24.index(date24.startIndex, offsetBy: 2)
        
        
        return date24.substring(to: index)
        
    }*/
    
   

    func uiDesign() {
        
        
        changeSettingButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        changeSettingButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        changeSettingButtonView.layer.shadowOpacity = 0.8
        changeSettingButtonView.layer.shadowRadius = 10.0
        changeSettingButtonView.layer.masksToBounds = false
        
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



