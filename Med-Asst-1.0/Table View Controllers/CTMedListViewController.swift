//
//  CTMedListViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 21/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit


class CTMedListViewController: UITableViewController {
    
    var catchPatientName: String?
    
    var catchSwitchNum: Int?
    
    var currentRow: Int?
    
    var messageFlag: Bool?
    
    var medicines: [Medicine] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "\(catchPatientName!)'s Medicine"
        
        if messageFlag != nil {
            self.createAlert(title: "", message: "A red exclamation means today's medicine has been missed, a green tick means the medicine was taken. Click on a medicine for more information")
            messageFlag = nil
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        User.current.medicineArray = []
        UserMedService.fetchDataAtUuid(atUuidValue: User.current.uuid, onCompletion: { (medicineArrayFromBase) in
            
            if medicineArrayFromBase == nil {
                print("connected to internet to continue, it's not fetching data from firebase")
            }
                
            else {
                print("I did fetch!!!!!!")
                User.current.medicineArray = medicineArrayFromBase
                self.medicines = User.current.medicineArray!
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return medicines.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        currentRow = indexPath.row
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ctMedCellID", for: indexPath) as! CTMedListViewCell
        
        cell.medNameLabel.text = medicines[currentRow!].name
        cell.medNicknameLabel.text = medicines[currentRow!].nickname
        
        ///
        //get today
        let today = Date()
        let calendar = Calendar.current
        let monthNow = calendar.component(.month, from: today)
        let dayNow = calendar.component(.day, from: today)
        let yearNow = calendar.component(.year, from: today)
        let hourNow = calendar.component(.hour, from: today)
        //let minuteNow = calendar.component(.minute, from: today)
        
        var allText: String = ""
        for (_,value) in (medicines[currentRow!].notificationIDs) {
            
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
            
            cell.okSignView.isHidden = false
            cell.warningSignView.isHidden = true
            
        }
        else {
            
            cell.okSignView.isHidden = true
            cell.warningSignView.isHidden = false
        
        }

        ///
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCTMedDetailView" {
        let cTMedDetailVC = segue.destination as! CTMedDetailViewController
            cTMedDetailVC.catchIndexRow = tableView.indexPathForSelectedRow!.row
        }
    }
    
    @IBAction func unwindToCTMedList(_ segue: UIStoryboardSegue) {
        
    }
    
    func createAlert(title: String, message: String) {
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        newAlert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(newAlert, animated: true, completion: nil)
        
    }

    

}
