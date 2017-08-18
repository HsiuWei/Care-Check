//
//  SwitchPatientListViewController.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 23/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit

class SwitchPatientListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Medicine.patientNameArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchPatientCellID", for: indexPath) as! SwitchPatientListViewCell

        cell.patientNameLabel.text =  Medicine.patientNameArray[indexPath.row]
        cell.patientUuidLabel.text =  Medicine.careTakerUuidArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwinfFromSwitchCellToHome" {
            let cTHomeVC = segue.destination as! CTHomeVIewController
            cTHomeVC.switchNum = tableView.indexPathForSelectedRow!.row
            
            //store the switch number as history so that the user can start from the last user they switched to when openning the app again
            UserDefaults.standard.set(tableView.indexPathForSelectedRow!.row, forKey: UDkeys.switchPatientNumber.switchPatientNumberkey)
        }
    }
    
    
    //deleting patient names function
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            Medicine.patientNameArray.remove(at: indexPath.row)
            UserDefaults.standard.set(Medicine.patientNameArray, forKey: UDkeys.patientName.patientNamekey)
            
            Medicine.careTakerUuidArray.remove(at: indexPath.row)
            UserDefaults.standard.set(Medicine.careTakerUuidArray, forKey: UDkeys.careTakerUuid.careTakerUuidkey)
            
            let currentSwitchNum = UserDefaults.standard.value(forKey: UDkeys.switchPatientNumber.switchPatientNumberkey) as! Int!
            if currentSwitchNum == 0 {
            }
            else {
                let updateSwitchNum = currentSwitchNum! - 1
                UserDefaults.standard.set(updateSwitchNum, forKey: UDkeys.switchPatientNumber.switchPatientNumberkey)
            }
            
            
            tableView.reloadData()
        }
        
    }

    
    
}
