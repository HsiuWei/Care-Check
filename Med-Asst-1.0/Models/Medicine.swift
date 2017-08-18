//
//  Medicine.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 27/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

class Medicine {
    
    var medUid: String!
    
    var name: String?
    var nickname: String?
    
    var fromDate = Date()
    var toDate = Date()
    
    var amount: Int?
    var frequency: Int?
    var unit: String? //this is note
    
    static var careTakerUuidArray = [String]()
    static var patientNameArray = [String]()
    
    var notificationIDs: [String: String] = [:]
  
    //for the add med vc
    convenience init (name: String, nickname: String) {
        self.init(name: name, nickname: nickname, fromDate: Date(), toDate: Date(), amount: 0, frequency: 0, unit: "", notificationIDs: [:])
    }
    
    //for the period vc
    convenience init (name: String, nickname: String, fromDate: Date, toDate: Date) {

        self.init(name: name, nickname: nickname, fromDate: fromDate, toDate: toDate, amount: 0, frequency: 0, unit: "", notificationIDs: [:])
        
    }
    
    //for the amount vc
    convenience init (name: String, nickname: String, fromDate: Date, toDate: Date, amount: Int, frequency: Int, unit: String) {
        
        self.init(name: name, nickname: nickname, fromDate: fromDate, toDate: toDate, amount: amount, frequency: frequency, unit: unit, notificationIDs: [:])
        
    }

    
    //for the confirmation vc, the final one
    init(name: String, nickname: String, fromDate: Date, toDate: Date, amount: Int, frequency: Int, unit: String, notificationIDs: [String: String]) {
        self.name = name
        self.nickname = nickname
        self.fromDate = fromDate
        self.toDate = toDate
        self.amount = amount
        self.frequency = frequency
        self.unit = unit
        self.notificationIDs = notificationIDs
    }



    //for putting data into firebase, create a dictionary
    var medDictionaryForDatabse: [String: Any]? {

        //for transforming Date type into string
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let fromDateAsString = formatter.string(from: fromDate)
        let toDateAsString = formatter.string(from: toDate)
        
        guard let name = name, let nickname = nickname, let amount = amount, let frequency = frequency, let unit = unit else
        {
            return nil
        }
        
        return ["Medicine Title": name,
                "Medicine Nickname": nickname,
                "From Time": fromDateAsString,
                "To Time": toDateAsString,
                "Number of Pills": amount,
                "Period": frequency,
                "Unit": unit,
                "Med Notification Array": notificationIDs]
    }
    
    //failable initializer for retrieving data from firebase
    init?(snapshot: DataSnapshot) {
        //if the snapshot is not nil
        guard let dict = snapshot.value as? [String: Any],
            let name = dict["Medicine Title"] as? String,
            let nickname = dict["Medicine Nickname"] as? String,
            let fromDate = dict["From Time"] as? String,
            let toDate = dict["To Time"] as? String,
            let frequency = dict["Period"] as? Int,
            let amount = dict["Number of Pills"] as? Int,
            let unit = dict["Unit"] as? String,
        let notificationIDs = dict["Med Notification Array"] as? [String: String]
        else {
            
                return nil
        }
        
        //for transforming type String into Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        guard let fromDateAsDate = formatter.date(from: fromDate), let toDateAsDate = formatter.date(from: toDate) else {
            return nil
        }
        
        //create new medicine object
        self.medUid = snapshot.key
        self.name = name
        self.nickname = nickname
        self.fromDate = fromDateAsDate
        self.toDate = toDateAsDate
        self.frequency = frequency
        self.amount = amount
        self.unit = unit
        self.notificationIDs = notificationIDs
 
    }
    

    
    
    
}
