//
//  GlobalEnums.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 14/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation

//String means the rawVlaue is a string
enum UDkeys: String {
    
    case uuid
    //key is a read-only variable that returns a string
    var key: String {
        //rawValue returns case as a string
        return self.rawValue + "Key"
    }

    

    case careTakerUuid
    case patientName
    
    var careTakerUuidkey: String {
        return self.rawValue + "Key"
    }
    
    var patientNamekey: String {
        return self.rawValue + "Key"
    }
    
    
    case switchPatientNumber
    
    var switchPatientNumberkey: String {
        return self.rawValue + "Key"
    }
    
    case userWakeTime
    var userWakeTimekey: String {
        return self.rawValue + "Key"
    }
    
    case userSleepTime
    var userSleepTimkey: String {
        return self.rawValue + "Key"
    }
    
    case careTakerUsedFlag
    var careTakerUsedFlagkey: String {
        return self.rawValue + "Key"
    }
    
    
    //for tutorial alert message
    
    case tutorialMessageFlag
    var tutorialMessageFlagkey: String {
        return self.rawValue + "Key"
    }

    
    case doneNotificationIds
    var doneNotificationIdskey: String {
        return self.rawValue + "Key"
    }


    

    

}
