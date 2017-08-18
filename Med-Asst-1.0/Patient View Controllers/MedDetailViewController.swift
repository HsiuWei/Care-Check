//
//  MedDetailViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 18/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit
import Firebase

import UserNotifications

class MedDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var catchIndexPath : Int?
    
    @IBOutlet weak var seeScheduleButtonView: UIButton!
    
    @IBOutlet weak var HomeBackgroundView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBOutlet weak var amountPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var noteTextField: UITextView!
 
    let options = ["1","2","3","4","5"]
    var pillAmountInt: Int!
    var timePeriodInt: Int!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        uiDesign()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MedDetailViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        fromDatePicker.minimumDate = Date()
        fromDatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: +1, to: Date())
        
        toDatePicker.minimumDate = Date()
        toDatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: +1, to: Date())
        
        
        
        if catchIndexPath != nil {
            
            nameTextField.text = User.current.medicineArray?[catchIndexPath!].name
            nicknameTextField.text = User.current.medicineArray?[catchIndexPath!].nickname
            
            
            setDatePickersPosition(fromDate: (User.current.medicineArray?[catchIndexPath!].fromDate)!,toDate: (User.current.medicineArray?[catchIndexPath!].toDate)!)
            
            pillAmountInt = User.current.medicineArray![catchIndexPath!].amount!
            timePeriodInt = User.current.medicineArray![catchIndexPath!].frequency!
            setAmountPickersPosition(amount: User.current.medicineArray![catchIndexPath!].amount!, time: User.current.medicineArray![catchIndexPath!].frequency!)

            
            noteTextField.text = User.current.medicineArray?[catchIndexPath!].unit
            
            decideButtonImage(indexPath: catchIndexPath!)
            

        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let copyMedicineObjForDeleteNotifications: [String: String] = (User.current.medicineArray?[catchIndexPath!].notificationIDs)!

        
        if segue.identifier == "toListViewFromSave" {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
    
            if (fromDatePicker.date <= toDatePicker.date) && nameTextField.text != "" && nicknameTextField.text != "" {
                
                //make a copy for deleting notifications, since it might take a while to delete, so let the putting new data go first
                
                User.current.medicineArray?[self.catchIndexPath!].notificationIDs = [:]
                
                User.current.medicineArray?[self.catchIndexPath!].name = self.nameTextField.text
                User.current.medicineArray?[self.catchIndexPath!].nickname = self.nicknameTextField.text
                
                User.current.medicineArray?[self.catchIndexPath!].unit = self.noteTextField.text
                
                User.current.medicineArray?[self.catchIndexPath!].fromDate = self.fromDatePicker.date
                User.current.medicineArray?[self.catchIndexPath!].toDate = self.toDatePicker.date
                
                User.current.medicineArray?[self.catchIndexPath!].amount = self.pillAmountInt
                User.current.medicineArray?[self.catchIndexPath!].frequency = self.timePeriodInt
                
                ////////
                ReminderHelperClass.putTriggerDateToFirebase(for: (User.current.medicineArray?[self.catchIndexPath!])!)
                
                let finalMedWithNotificationIDs = Medicine(name: (User.current.medicineArray?[self.catchIndexPath!].name)!, nickname: (User.current.medicineArray?[self.catchIndexPath!].nickname)!, fromDate: (User.current.medicineArray?[self.catchIndexPath!].fromDate)!, toDate: (User.current.medicineArray?[self.catchIndexPath!].toDate)!, amount: (User.current.medicineArray?[self.catchIndexPath!].amount)!, frequency: (User.current.medicineArray?[self.catchIndexPath!].frequency)!, unit: (User.current.medicineArray?[self.catchIndexPath!].unit)!, notificationIDs: (User.current.medicineArray?[self.catchIndexPath!].notificationIDs)!)
                
                let aMedDict = finalMedWithNotificationIDs.medDictionaryForDatabse
                
                let databaseRef = Database.database().reference().child("Users").child(User.current.uuid).child((User.current.medicineArray?[self.catchIndexPath!].medUid)!)
                
                databaseRef.updateChildValues(aMedDict!, withCompletionBlock: {(returnedError, returnedReference) in
                    if let temporaryReturnedError = returnedError {
                        print(temporaryReturnedError.localizedDescription)
                    }
                    else {
                        //successfully putting data
                    }
                })

                
                //and delete the notifications after the putting data
                deleteNotificationForMedicine(theMedicineToBeDeleted: copyMedicineObjForDeleteNotifications)
            }
            else {
                if nameTextField.text == "" || nicknameTextField.text == "" {
                    createAlert(title: "Please Enter Required Information", message: "")
                    return
                }
                else{
                    createAlert(title: "Please Choose Valid Date(s)", message: "")
                    return
                }
                

            }
            
        }
        
        else if segue.identifier == "toScheduleView" {
        
            let scheduleVC = segue.destination as! SeeScheduleViewController
            scheduleVC.catchIndexRow = catchIndexPath
        }
    }
    
    
    //in charge of deleting and recreating a notification for the medicine
    func deleteNotificationForMedicine(theMedicineToBeDeleted: [String: String]) {
    
        var notifiIDsToBeDeleted: [String] = []
        for (key,_) in (theMedicineToBeDeleted) {
        notifiIDsToBeDeleted.append(key)
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notifiIDsToBeDeleted)
        
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
    
        
    func setDatePickersPosition(fromDate: Date, toDate: Date) {
    
        
        //set the position of the date
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat =  "dd/MM/yyyy"
        
       // let date = dateFormatter.date(from: "27/12/2017")
        
        fromDatePicker.date = fromDate
        toDatePicker.date = toDate
    
    }
    
    func createAlert(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
        self.present(newAlert, animated: true, completion: nil)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //1 row needed only
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == amountPicker {
            
            pillAmountInt = Int(options[row])!
            
        }
            
        else {
            
            timePeriodInt = Int(options[row])!
           
        }
        User.current.medicineArray?[self.catchIndexPath!].amount = pillAmountInt
        User.current.medicineArray?[self.catchIndexPath!].frequency = timePeriodInt
        

    }
    
    func setAmountPickersPosition(amount: Int, time: Int) {
    
        amountPicker.selectRow(amount - 1, inComponent: 0, animated: false)
        timePicker.selectRow(time - 1, inComponent: 0, animated: false)

    
    }

    
    
    //override func prepar
    
    @IBAction func seeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toScheduleView", sender: self)
    }
    
    @IBAction func unwindFromscheduleVCToDetailVC(_ segue: UIStoryboardSegue) {
        print("back from detail view to list view")
    }
    
    func decideButtonImage(indexPath: Int) {
        ////
        let today = Date()
        let calendar = Calendar.current
        let monthNow = calendar.component(.month, from: today)
        let dayNow = calendar.component(.day, from: today)
        let yearNow = calendar.component(.year, from: today)
        let hourNow = calendar.component(.hour, from: today)
        //let minuteNow = calendar.component(.minute, from: today)
        
        var allText: String = ""
        for (_,value) in (User.current.medicineArray?[catchIndexPath!].notificationIDs)! {
            
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
            
            //seeScheduleButtonView  = UIButton(type: .custom)
            
            let myImage = UIImage(named: "See Schedule Button Gray")
            seeScheduleButtonView.setImage(myImage, for: .normal)
            
            
        }
        else {
            //seeScheduleButtonView  = UIButton(type: .custom)
            
            let myImage = UIImage(named: "See Schedule Buttons")
            seeScheduleButtonView.setImage(myImage, for: .normal)
            
                      
        }
        
        ////
        
    }



    

    
    
}

