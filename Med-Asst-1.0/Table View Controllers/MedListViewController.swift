//
//  MedListViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 18/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit
import Firebase

import UserNotifications

class MedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var greetingWordsLabel: UILabel!
    
    @IBOutlet weak var medTableView: UITableView!
    
    @IBOutlet weak var addButtonView: UIButton!
    
    var timer: Timer?
    
    var medicines: [Medicine] = [] {
        didSet {
            medTableView.reloadData()
            
        } 
    }
    
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        uiDesign()
        

        //tutorial message
        if UserDefaults.standard.value(forKey: UDkeys.tutorialMessageFlag.tutorialMessageFlagkey) as! Bool == true {
            self.createAlert(title: "Welcome!", message: "Make sure Wifi is turned on and click \"+Add\" to add new medicines. Click \"Settings\" to see or share your pair code and change your waking hours. Once medicines are created, FamCare will send you medicine notifications to remind you. Be sure to allow sending notifications for FamCare on your iphone.")
        }
    
        
        helper()
        
        //conform to tableview protocols, set deleagtes
        medTableView.delegate = self
        medTableView.dataSource = self
        
        UserMedService.fetchDataAtUuid(atUuidValue: User.current.uuid, onCompletion: {(medArrayFromBase) in
            User.current.medicineArray = medArrayFromBase
            self.medicines = User.current.medicineArray!
            ////////////////////////////////////////////////////////////////check the array!!!!!
            
        })
        
     
    }
    
    func createAlert(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }

    
    func helper() {
        //retrieve the uuid we ceated from the UserDefaults
        if let theUuid = UserDefaults.standard.value(forKey: UDkeys.uuid.key) {
            
            //retrieve the uuid of the user into a User class
            let thisUser = User(uuid: theUuid as! String)
            
            //make this user a singleton user (current)
            User.setSingleton(thisUser)
            
           // uuidDisplayLabel.text = User.current.uuid
            
            //fetch data from databse
            UserMedService.fetchDataAtUuid(atUuidValue: User.current.uuid, onCompletion: { (medicineArrayFromBase) in
                if medicineArrayFromBase == nil {
                    print("connected to internet to continue, it's not fetching data from firebase")
                }
                    
                else {
        
                    User.current.medicineArray = medicineArrayFromBase
                    self.medicines = User.current.medicineArray!

                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UserMedService.fetchDataAtUuid(atUuidValue: User.current.uuid, onCompletion: {(medArrayFromBase) in
            User.current.medicineArray = medArrayFromBase
            self.medicines = User.current.medicineArray!
            
            self.autoDeleteMedExpired()
        
            self.updateFirebaseWithTappedNotification()
            
            //schedule for today
            ScheduleTodayNotificationHelperClass.scheduleTodayNotification()
            
        })
        
        greeting()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.greeting), userInfo: nil, repeats: true)
        
        
        //see all notifications of this medicine
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print("XD :D \(request)")
            }
        })
        
        
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if medicines.count <= 12 {
            performSegue(withIdentifier: "toAddMedView", sender: self)
        }
        else {
           createAddAlert(title: "Exceed 12 medicine items", message: "Sorry, a user can only schedule 12 medicine items.")
            
        }
    }
    
    func greeting() {
        //for greeting
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if hour > 4 && hour < 11 {
            greetingWordsLabel.text = "Good Morning!"
        }
        else if hour >= 11 && hour <= 12 {
            greetingWordsLabel.text = "Good Day!"
        }
        else if hour > 12 && hour < 17 {
            greetingWordsLabel.text = "Good Afternoon!"
        }
        else {
            greetingWordsLabel.text = "Good Evening!"
        }
        
    }
    
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let oneMedicineForRow = medicines[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "medCellID", for: indexPath) as! MedListViewCell
        
        cell.nameLabel.text = oneMedicineForRow.name
        cell.nicknameLabel.text = oneMedicineForRow.nickname
        
        ////
        let today = Date()
        let calendar = Calendar.current
        let monthNow = calendar.component(.month, from: today)
        let dayNow = calendar.component(.day, from: today)
        let yearNow = calendar.component(.year, from: today)
        let hourNow = calendar.component(.hour, from: today)
        //let minuteNow = calendar.component(.minute, from: today)
        
        var allText: String = ""
        for (_,value) in (oneMedicineForRow.notificationIDs) {
            
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
            
            cell.okSign.isHidden = false
            cell.warningSign.isHidden = true
            
        }
        else {
            
            cell.okSign.isHidden = true
            cell.warningSign.isHidden = false
            
        }

        ////
        
        //For Protocol
        let currentRow = indexPath.row
        cell.catchRow = currentRow
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMedDetailView" {
            
            //set the dstination view controller, remember to start from the navigation bar, since we're using the modally segue, no navigation will be connected unless we add one
            //let navVC = segue.destination as! UINavigationController
            //let detailVC = navVC.topViewController as! MedDetailViewController
            
            let detailVC = segue.destination as! MedDetailViewController
            
            //tell the compiler the sender is of type Int, since it accepts Any?
            let rowSender = sender as! Int
            
            detailVC.catchIndexPath = rowSender
        }
    }
    
    @IBAction func unwindFromDetailVCToListVC(_ segue: UIStoryboardSegue) {
        print("back from detail view to list view")
    }
    
    @IBAction func unwindFromConfirmationVCToMedListVC(_ segue: UIStoryboardSegue) {
        print("back from confirmation view to home view of PT")
    }
 
    
    func autoDeleteMedExpired() {
    
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let today = Date()
        
    
        if User.current.medicineArray?.count != 0 {
            
            for i in 0...(User.current.medicineArray?.count)! - 1 {
                
                let date2 = calendar.startOfDay(for: (User.current.medicineArray?[i].toDate)!)
                let components = calendar.dateComponents([.day], from: date2, to: today)
                let difference = components.day
                
                if ((User.current.medicineArray?[i].toDate)! < today) && (difference! >= 1) {
                    print("thid medicine has expired more than 24 hours")
                    let deleteRef = Database.database().reference().child("Users").child(User.current.uuid).child((User.current.medicineArray?[i].medUid)!)
                    
                    deleteRef.removeValue(completionBlock: { (error, ref) in
                        if error != nil {
                            print("error happened when deleting child in firebase")
                        }
                    })
                    
                    //fetch again to refreah the table view
                    UserMedService.fetchDataAtUuid(atUuidValue: User.current.uuid, onCompletion: {(medArrayFromBase) in
                        User.current.medicineArray = medArrayFromBase
                        self.medicines = User.current.medicineArray!
                    })

                }

            }
        }

    
    }
    
    func updateFirebaseWithTappedNotification() {
    
        var medUidInFbs: [String] = []
        
        for medicine in User.current.medicineArray! {
            
            if UserDefaults.standard.stringArray(forKey: UDkeys.doneNotificationIds.doneNotificationIdskey) != nil {
            
                for notificationID in UserDefaults.standard.stringArray(forKey: UDkeys.doneNotificationIds.doneNotificationIdskey)!{
                    
                    for (key,_) in medicine.notificationIDs {
                        
                        if key == notificationID {
                            medUidInFbs.append(medicine.medUid)
                        }
                        
                    }
                }
            
            }
            
            else {
                return
            }
            
        }
        
        for uid in medUidInFbs {
             for notificationID in UserDefaults.standard.stringArray(forKey: UDkeys.doneNotificationIds.doneNotificationIdskey)!{
        
                let databaseRef = Database.database().reference().child("Users").child(User.current.uuid).child(uid).child("Med Notification Array").child(notificationID)

                databaseRef.removeValue(completionBlock: { (error, ref) in
                    if error != nil {
                            print("error happened when deleting child in firebase")
                    }
                })
            
            }
        }
        
        
    }
    
    func uiDesign() {
    
        addButtonView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        addButtonView.layer.shadowOffset = CGSize(width: 3, height: 3)
        addButtonView.layer.shadowOpacity = 0.8
        addButtonView.layer.shadowRadius = 10.0
        addButtonView.layer.masksToBounds = false

    }
    
    func createAlertForDeleteButton(title: String, message: String, row: Int) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))

        newAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
            self.deleteAfterMessageShowing(row: row)
        }))

        
        self.present(newAlert, animated: true, completion: nil)
        
    }
    
    func createAddAlert(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }


    
}



extension MedListViewController: MedListViewCellProtocol {
    
    func presentSegue(with row: Int) {
        
        //send row only via this segue
        performSegue(withIdentifier: "toMedDetailView", sender: row)
        //the prepare(for segue) function will be called first before the segue is actually reiggered
    
    }
    
    func deleteMed(at row: Int) {
        
        print("delete button tapped!!")
        createAlertForDeleteButton(title: "Delete this medicine?", message: "Notifications of this medicine will no longer be sent.", row: row)
        
    }
    
    func deleteAfterMessageShowing(row: Int) {
        //copy the medicine obj first
        let copyMedicineObjForDeleteNotification = User.current.medicineArray?[row]
        
        
        //delete it in the firebase
        let deleteRef = Database.database().reference().child("Users").child(User.current.uuid).child((User.current.medicineArray?[row].medUid)!)
        
        deleteRef.removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("error happened when deleting child in firebase")
            }
        })
        //fetch again to refreah the table view
        UserMedService.fetchDataAtUuid(atUuidValue: User.current.uuid, onCompletion: {(medArrayFromBase) in
            User.current.medicineArray = medArrayFromBase
            self.medicines = User.current.medicineArray!
        })
        
        var notifiIDsToBeDeleted: [String] = []
        for (key,_) in (copyMedicineObjForDeleteNotification?.notificationIDs)! {
            notifiIDsToBeDeleted.append(key)
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notifiIDsToBeDeleted)
        
    
    }
    
   
}

