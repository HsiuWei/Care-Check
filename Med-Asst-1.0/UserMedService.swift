//
//  UserMedService.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 17/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit
import Firebase

class UserMedService {

    //give me the Uuid and I'll fetch the data for you!!
    //code put into oncompletion will run only after the whole peace of .observeSingleEvent ends
    static func fetchDataAtUuid(atUuidValue theUuid: String, onCompletion: @escaping ([Medicine]?) -> Void ) {
       

           Database.database().reference().child("Users").child(theUuid).observe(.value, with: { (returnedSnapshot) in
       
            //return an array of type snapshots
            if let allMedSnapshotArray = returnedSnapshot.children.allObjects as? [DataSnapshot] {
           
                //create a new array for storing all the dictionary
                var medicinesArray = [Medicine]()
                for oneMedSnapshot in allMedSnapshotArray {
                    if let newSnapToTypeMed = Medicine(snapshot: oneMedSnapshot) {
                        medicinesArray.append(newSnapToTypeMed)
                    }
                }
                
                onCompletion(medicinesArray)
            }
            else {
                onCompletion(nil)
                return
            }
            
        })
    
    }
    
    static func putMedicine(put medObj: Medicine, atThisUuid userUID: String, onCompletion: @escaping (String) -> Void) {

        //open a space in firebase's database!! and set the data there
        let databaseRef = Database.database().reference().child("Users").child(userUID).childByAutoId()
        
        //convert obj into dictionary
        let medDict = medObj.medDictionaryForDatabse
        
        //make sure creating dictionry successfully
        if medDict != nil {
            
            databaseRef.updateChildValues(medDict!, withCompletionBlock: {(returnedError, returnedReference) in
                if let temporaryReturnedError = returnedError {
                    print(temporaryReturnedError.localizedDescription)
                    return onCompletion("Failure")
                }
                else {
                    return onCompletion("Success")
                }
            })
        }
        else {
            onCompletion("Failure")
            return
        }
    }
}
