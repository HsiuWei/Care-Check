//
//  CTMedDetailViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 22/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit

class CTMedDetailViewController: UIViewController {
    
    var catchIndexRow: Int?

    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var HomePageBackground: UIImageView!
    
    @IBOutlet weak var nameCardView: UIView!
    @IBOutlet weak var periodCardView: UIView!
    @IBOutlet weak var amountCardView: UIView!
    @IBOutlet weak var textFieldCardView: UIView!
    @IBOutlet weak var noteCardView: UIView!
    
    @IBOutlet weak var medNameLabel: UILabel!
    @IBOutlet weak var medNicknameLabel: UILabel!
    
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!

    @IBOutlet weak var missDateTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        uiDesign()
        
        if catchIndexRow != nil {
            
            medNameLabel.text = User.current.medicineArray?[catchIndexRow!].name
            medNicknameLabel.text = User.current.medicineArray?[catchIndexRow!].nickname
            
            //
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            
            let fromDateAsString = formatter.string(from: (User.current.medicineArray?[catchIndexRow!].fromDate)!)
            fromTimeLabel.text = fromDateAsString
            
            let toDateAsString = formatter.string(from: (User.current.medicineArray?[catchIndexRow!].toDate)!)
            toTimeLabel.text = toDateAsString
            
            amountLabel.text = String(describing: User.current.medicineArray![catchIndexRow!].amount!)
            periodLabel.text = String(describing: User.current.medicineArray![catchIndexRow!].frequency!)
            if User.current.medicineArray?[catchIndexRow!].unit != "" {
                unitLabel.text = User.current.medicineArray?[catchIndexRow!].unit
            }
            
            //get today
            let today = Date()
            let calendar = Calendar.current
            let monthNow = calendar.component(.month, from: today)
            let dayNow = calendar.component(.day, from: today)
            let yearNow = calendar.component(.year, from: today)
            let hourNow = calendar.component(.hour, from: today)
            //let minuteNow = calendar.component(.minute, from: today)
            
            var allText: String = ""
            for (_,value) in (User.current.medicineArray?[catchIndexRow!].notificationIDs)! {
                
                let dateString = value
                let dateStringArray = dateString.components(separatedBy: " ")
                
                let time = dateStringArray[0]
                let timeStringArray = time.components(separatedBy: ":")
                let hour = Int(timeStringArray[0])
                //let minute = Int(timeStringArray[1])
                
                let date = dateStringArray[1]
                let montheDayYearStringArray = date.components(separatedBy: "/")
                let month = Int(montheDayYearStringArray[0])
                let day = Int(montheDayYearStringArray[1])
                let year = Int(montheDayYearStringArray[2])
                
                               
            
                if hour! < hourNow && month == monthNow && day! == dayNow && year! == yearNow {
    
                    allText = allText + value + "\n"
                }
            }
            
            if allText == "" {
            
                missDateTextView.text = "The patient hasn't missing taking any medicine till now today"
                self.textFieldCardView.backgroundColor = UIColor(red: 167/255.0, green: 255/255.0, blue: 226/255.0, alpha: 0.39)
            
            }
            else {
                
                missDateTextView.text = "Today's missing:" + "\n" + allText
                self.textFieldCardView.backgroundColor = UIColor(red: 255/255.0, green: 148/255.0, blue: 155/255.0, alpha: 0.23)
            
            }
            
        
        }
        
        else {
            //the index path is nil
        }
    
    }
    
       
    func uiDesign() {
        
        
        nameCardView.layer.cornerRadius = 3.0
        nameCardView.layer.masksToBounds = false
        nameCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        nameCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameCardView.layer.shadowOpacity = 0.8
        
        periodCardView.layer.cornerRadius = 3.0
        periodCardView.layer.masksToBounds = false
        periodCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        periodCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        periodCardView.layer.shadowOpacity = 0.8
        
        amountCardView.layer.cornerRadius = 3.0
        amountCardView.layer.masksToBounds = false
        amountCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        amountCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        amountCardView.layer.shadowOpacity = 0.8
        
        textFieldCardView.layer.cornerRadius = 3.0
        textFieldCardView.layer.masksToBounds = false
    
        
        textFieldCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        textFieldCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        textFieldCardView.layer.shadowOpacity = 0.8
        
       
        if User.current.medicineArray?[self.catchIndexRow!].unit != "" {
            
            noteCardView.isHidden = false
            noteCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            noteCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
            noteCardView.layer.shadowOpacity = 0.8
        
        }
        
        else {
        
            noteCardView.isHidden = true
            noteLabel.isHidden = true
        
        }
        
        
        HomePageBackground.clipsToBounds = true
        HomePageBackground.isHidden = false
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomePageBackground.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomePageBackground.addSubview(blurView)

        
    }
    
    
    
    

}
