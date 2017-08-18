//
//  ScheduleTodayNotificationHelperClass.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 13/08/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class ScheduleTodayNotificationHelperClass {
    
    static func scheduleTodayNotification() {
    
        var medicines: [Medicine] = []
        
        UserMedService.fetchDataAtUuid(atUuidValue: User.current.uuid, onCompletion: {(medArrayFromBase) in
            User.current.medicineArray = medArrayFromBase
            medicines = User.current.medicineArray!
            ////////////////////////////////////////////////////////////////check the array!!!!!
            for medicine: Medicine in medicines {
                
                for (key, value) in medicine.notificationIDs {
                    //key is notifiuuid
                    //value is date string
                    
                    //value - > Date
                    let theTriggerDate: Date = ScheduleTodayNotificationHelperClass.breakStringToTypeDate(entireTimeString: value)
                    let isToday: Bool = checkDateIsToday(test: theTriggerDate)
                    if isToday == true {
                        //then schedule it with notifi indentifier:
                        var existedNotifiIDs: [String] = []
                        
                        let center = UNUserNotificationCenter.current()
                        center.getPendingNotificationRequests(completionHandler: { requests in
                            for request in requests {
                                existedNotifiIDs.append(request.identifier)
                            }
                        })
                        
                        if existedNotifiIDs.count != 0 {
                            for notifiID in existedNotifiIDs {
                                if notifiID == key {
                                
                                }
                                    
                                else {
                                    let triggerDate: UNCalendarNotificationTrigger?
                                    triggerDate = ScheduleTodayNotificationHelperClass.createTriggerDate(date: theTriggerDate)
                                    scheduleNotification(medicineObj: medicine, notifiUuid: key, trigger: triggerDate!)
                                }
                            }
                        }
                        else {
                            let triggerDate: UNCalendarNotificationTrigger?
                            triggerDate = ScheduleTodayNotificationHelperClass.createTriggerDate(date: theTriggerDate)
                            scheduleNotification(medicineObj: medicine, notifiUuid: key, trigger: triggerDate!)
                        
                        }
                    }
                }
            }

        })
        
    }
    
    
    
    static func breakStringToTypeDate(entireTimeString: String)-> Date {
    
        let entireDateString = entireTimeString
        let dateStringArray = entireDateString.components(separatedBy: " ")
        
        let time = dateStringArray[0]
        let timeStringArray = time.components(separatedBy: ":")
        let hour = Int(timeStringArray[0])
        let minute = Int(timeStringArray[1])
        
        let date = dateStringArray[1]
        let montheDayYearStringArray = date.components(separatedBy: "/")
        let month = Int(montheDayYearStringArray[0])
        let day = Int(montheDayYearStringArray[1])
        let year = Int(montheDayYearStringArray[2])
        
        
        var comp = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        comp.hour = hour
        comp.minute = minute
        comp.second = 0
        comp.month = month
        comp.day = day
        comp.year = year
        let triggerTime = Calendar.current.date(from: comp)
        
        return triggerTime!
        
    }
    static func scheduleNotification(medicineObj: Medicine, notifiUuid: String, trigger: UNCalendarNotificationTrigger) {
    
        
        let medReminder = UNMutableNotificationContent()
        medReminder.title = "Time to take the medicine: " + medicineObj.name!
        medReminder.subtitle = "Take " + String(describing: medicineObj.amount!) + " pill(s)"
        medReminder.body = "Swipe to see the midicine info in app"
        medReminder.badge = 1
        
        
        //create user respond options(actions) after seeing the reminder
        let doneOption = UNNotificationAction(identifier: "doneOptionID", title: "Taken!", options: UNNotificationActionOptions.foreground)
        //let snoozeOption = UNNotificationAction(identifier: "snoozeOptionID", title: "Snooze", options: UNNotificationActionOptions.foreground)
        //the actions neeeded to be put into a category, put them into the "actions array"
        let medCategory = UNNotificationCategory(identifier: "medCategoryID", actions: [doneOption], intentIdentifiers: [], options: [])
        //connect to the medRemoder window
        medReminder.categoryIdentifier = "medCategoryID"
        
        
        //////////////////
        var reminderRequest: UNNotificationRequest?
        reminderRequest = UNNotificationRequest(identifier: notifiUuid, content: medReminder, trigger: trigger)
    
        //connect our category onto the center, using set... function, put the category into one array
        UNUserNotificationCenter.current().setNotificationCategories([medCategory])
        UNUserNotificationCenter.current().add(reminderRequest!, withCompletionHandler: nil)


    
    }
    
    
    static func createTriggerDate(date: Date)-> UNCalendarNotificationTrigger {
        //format the input date into a NSCalender
        var calendar = Calendar.current
        
        
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        calendar.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)!
        
        calendar.timeZone = TimeZone.current
        
        //let zone = calendar.component(.timeZone, from: date)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        //put the formatted calendar type into DateComponents, notice day is a variable
        var dateComponentsForTrigger = DateComponents()
        
        dateComponentsForTrigger.year = year
        dateComponentsForTrigger.month = month
        dateComponentsForTrigger.day = day
        dateComponentsForTrigger.hour = hour
        dateComponentsForTrigger.minute = minute
        
        let medReminderTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsForTrigger, repeats: false)
        return medReminderTrigger
    }
    
    static func checkDateIsToday(test aDate: Date) -> Bool {
        
        //get today
        let today = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let year = calendar.component(.year, from: today)
        
        let components = Calendar.current.dateComponents([.day,.month,.year], from: aDate)
        let aDay = components.day
        let aMonth = components.month
        let aYear = components.year
        
        if aDay == day && aMonth == month && aYear == year {
            return true
        }
        else {
            return false
        }

    }


}
 
