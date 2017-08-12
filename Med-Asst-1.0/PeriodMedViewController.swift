//
//  PeriodMedViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 15/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit


class PeriodMedViewController: UIViewController {
    
    @IBOutlet weak var nextButtonView: UIButton!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    var catchNewMed: Medicine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiDesign()
        
        fromDatePicker.minimumDate = Date()
        fromDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: +2, to: Date())
        
        toDatePicker.minimumDate = Date()
        toDatePicker.maximumDate = Calendar.current.date(byAdding: .month, value: +2, to: Date())
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "toAmountMedView" {
            
           // if checkDatesAreReasonable(checkDateOne: fromDatePicker.date, checkDateTwo: toDatePicker.date) == true {
            
            
            if fromDatePicker.date <= toDatePicker.date {
                let med = Medicine(name: (catchNewMed?.name!)!, nickname: (catchNewMed?.nickname)!, fromDate: fromDatePicker.date, toDate: toDatePicker.date)
                
                let amountVC = segue.destination as! AmountMedViewController
                amountVC.catchMed = med
                
            }
            
            else {
                createAlert(title: "Please Choose Valid Date(s)", message: "")
                return
            }
           // }
           // else {
           //     createAlert(title: "Please Enter Valid Date(s)", message: "The date(s) can only start from today's date")
           //     return
           // }
        
        }

    }
    
    @IBAction func periodNextButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toAmountMedView", sender: self)
    }
    
    /*
    func checkDatesAreReasonable(checkDateOne: Date, checkDateTwo: Date) -> Bool{
        
        var result: Bool!
        
        //get today
        let today = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let year = calendar.component(.year, from: today)
        
        //get from date
        let fromComponents = Calendar.current.dateComponents([.day,.month,.year], from: checkDateOne)
        let fromDay = fromComponents.day
        let fromMonth = fromComponents.month
        let fromYear = fromComponents.year
        
        //get to date
        let toComponents = Calendar.current.dateComponents([.day,.month,.year], from: checkDateTwo)
        let toDay = toComponents.day
        let toMonth = toComponents.month
        let toYear = toComponents.year
        
        if fromYear! < year || fromMonth! < month || fromDay! < day || toYear! < year || toMonth! < month || toDay! < day {

            result = false
        }
        else {
            result = true
        }

        return result
    
    }*/
    
    func createAlert(title: String, message: String) {
    
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
        newAlert.addAction(UIAlertAction(title: "Got It", style: UIAlertActionStyle.default, handler: { (action) in
        newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }
    
    
    
    func uiDesign() {
        
        
        self.nextButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.nextButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.nextButtonView.layer.shadowOpacity = 0.8
        self.nextButtonView.layer.shadowRadius = 10.0
        self.nextButtonView.layer.masksToBounds = false
        
        HomeBackgroundView.clipsToBounds = true
        HomeBackgroundView.isHidden = false
        //get called after all the sub views are loaded
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = HomeBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        HomeBackgroundView.addSubview(blurView)
        
    }
    
    @IBAction func unwindToPeriod(_ segue: UIStoryboardSegue) {
    }


    
    
    
    
}


