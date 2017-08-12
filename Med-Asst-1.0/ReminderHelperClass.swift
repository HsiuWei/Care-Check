//
//  ReminderHelper.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 28/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//


import Foundation
import UIKit

import UserNotifications

class ReminderHelperClass {

    static func scheduleNotification(for medicineObj: Medicine) {
        
        //calculate period day sa anf create a data of time
        print("medicineObj.fromDate = \(medicineObj.fromDate)")
        print("medicineObj.toDate = \(medicineObj.toDate)")
        
        let reminderStartDate = changeStartTimeOfThisDate(date: medicineObj.fromDate)
        let reminderEndDate = changeEndTimeOfThisDate(date: medicineObj.toDate)
        
        //calculate day amounts and also call the function to check if it invovlves today
        let components = Calendar.current.dateComponents([.day], from: reminderStartDate, to: reminderEndDate)
        
        let numberOfDays = calculateNumberOfDays(medFromDate: medicineObj.fromDate, medToDate: medicineObj.toDate, originalComponentsDay: components.day!)
        
        
       //calculate waking hours
        let sleep24Sys = UserDefaults.standard.value(forKey: UDkeys.userSleepTime.userSleepTimkey) as! Int + 12
        let wake24Sys = UserDefaults.standard.value(forKey: UDkeys.userWakeTime.userWakeTimekey) as! Int
        let totalWakingHours = sleep24Sys - wake24Sys
        
        
        var frq: Double!
        if medicineObj.frequency == 1 {
            frq = 0
        }
        else {
            frq = Double(totalWakingHours)/Double((medicineObj.frequency! - 1))
        }
        
        
        var theMedReminderTrigger: UNCalendarNotificationTrigger?
        for dayIndex in 0...numberOfDays {
            
            //for the notification trigger times
            for multiplyByIndex in 0...(medicineObj.frequency! - 1) {
            
                print("Double(multiplyByIndex) * frq = \(Double(multiplyByIndex) * frq)")
                theMedReminderTrigger = ReminderHelperClass.createATrigger(startingFromDate: reminderStartDate, addingNumberOfDays: dayIndex, timeInterval: Double(multiplyByIndex) * frq, endDateForProtection: reminderEndDate)
                
                //////////=======cretate a notificaion obj
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
                
                            
                print("append one uuid to notificaion array once")
                //using uuid to generate id for each request
                let requestUuid: String = UUID().uuidString
                
    
                
                var reminderRequest: UNNotificationRequest?
                if theMedReminderTrigger != nil {
                    //create a notification, user is awake
                    reminderRequest = UNNotificationRequest(identifier: requestUuid, content: medReminder, trigger: theMedReminderTrigger)
                } else {
                    //user is sleeping
                }
                
                //connect our category onto the center, using set... function, put the category into one array
                UNUserNotificationCenter.current().setNotificationCategories([medCategory])
                
                if reminderRequest != nil {
                    
                    
                    UNUserNotificationCenter.current().add(reminderRequest!, withCompletionHandler: nil)
                        
                
                    let trigger = theMedReminderTrigger?.dateComponents
                    let triggerTimeString = String(describing: (trigger?.hour)!) + ":" + String(describing: (trigger?.minute)!) + " " + String(describing: (trigger?.month)!) + "/" + String(describing: (trigger?.day!)!) + "/" + String(describing: (trigger?.year!)!)
                    
                    medicineObj.notificationIDs[requestUuid] = triggerTimeString

                            
                }
                
            }
        }
        
    }
    
    
    private static func changeStartTimeOfThisDate(date: Date) -> Date {
        
        var comp = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        comp.hour = UserDefaults.standard.value(forKey: UDkeys.userWakeTime.userWakeTimekey) as? Int
        comp.minute = 0
        comp.second = 0
        
        let newDate = Calendar.current.date(from: comp)
        
        return newDate!
    }
    
    private static func changeEndTimeOfThisDate(date: Date) -> Date {
        
        var comp = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        comp.hour = (UserDefaults.standard.value(forKey: UDkeys.userSleepTime.userSleepTimkey) as? Int)! + 12
        comp.minute = 0
        comp.second = 0
        
        let newDate = Calendar.current.date(from: comp)
        
        return newDate!
    }


    
    static func createATrigger(startingFromDate date: Date, addingNumberOfDays indexDay: Int, timeInterval:Double, endDateForProtection: Date) -> UNCalendarNotificationTrigger? {
    
        
        let timeIntervalDouble:Double = timeInterval //3.75
        let numberOfPlaces:Double = 2.0
        let powerOfTen:Double = pow(10.0, numberOfPlaces)
        let targetedDecimalPlaces:Double = round(timeIntervalDouble.truncatingRemainder(dividingBy:1.0) * powerOfTen) / powerOfTen //0.75
        let minuteTimeInterval = Int(60 * targetedDecimalPlaces) //45
        let timeInterval: Int = Int(timeIntervalDouble - targetedDecimalPlaces)//3
        print("timeInterval = \(timeInterval)")
        
        //format the input date into a NSCalender
        var calendar = Calendar.current
        
        
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        print("localTimeZoneAbbreviation = \(localTimeZoneAbbreviation)")
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
        
        var numDaysOfTheMonth: Int!
        var totalDays = day + indexDay
        var varMonth = month
        
        var varYear = year
        
        repeat {
            numDaysOfTheMonth = ReminderHelperClass.calculateDaysInTheMonth(year: year, month: varMonth)
            if totalDays > numDaysOfTheMonth {
             totalDays = totalDays - numDaysOfTheMonth
             varMonth = varMonth + 1
                if varMonth > 12 {
                varMonth = varMonth - 1
                varYear = varYear + 1
                }
                
            }
            else {
                break
            }

        } while totalDays > numDaysOfTheMonth
        
        dateComponentsForTrigger.month = varMonth
        dateComponentsForTrigger.day = totalDays
        dateComponentsForTrigger.year = varYear
            
        
        
        
        
    


        dateComponentsForTrigger.hour = hour + timeInterval
        dateComponentsForTrigger.minute = minute + minuteTimeInterval
        
        //12:00am to nect day protection
        if dateComponentsForTrigger.hour == 24 && dateComponentsForTrigger.minute == 0 {
        
            dateComponentsForTrigger.hour = 23
            dateComponentsForTrigger.minute = 59
        
        }
        
        
        let medReminderTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsForTrigger, repeats: false)
        
        let calenderForTriggerCompo = Calendar.current
        let triggerDate = calenderForTriggerCompo.date(from: dateComponentsForTrigger)
        if  triggerDate! > endDateForProtection {
            return nil
        }
        else {
            return medReminderTrigger
        }
        
        
    }
    
    private static func calculateNumberOfDays(medFromDate: Date, medToDate: Date, originalComponentsDay: Int) -> Int {
        print("originalComponentsDay = \(originalComponentsDay)")
        
        //get today
        let today = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        let year = calendar.component(.year, from: today)
        
        //get from date
        let fromComponents = Calendar.current.dateComponents([.day,.month,.year], from: medFromDate)
        let fromDay = fromComponents.day
        let fromMonth = fromComponents.month
        let fromYear = fromComponents.year
        
        //get to date
        let toComponents = Calendar.current.dateComponents([.day,.month,.year], from: medToDate)
        let toDay = toComponents.day
        let toMonth = toComponents.month
        let toYear = toComponents.year
        
        var numberOfDays: Int!
        if fromMonth == month && fromDay == day && fromYear == year {
            if fromMonth == toMonth && fromDay == toDay && fromYear == toYear {
                numberOfDays = originalComponentsDay
            }
            else {
                numberOfDays = originalComponentsDay + 1
            }
        }
        else {
            numberOfDays = originalComponentsDay
        }
        print("numberOfdays = \(numberOfDays)")

        print("newlComponentsDay = \(numberOfDays)")
        return numberOfDays
    
    }
    
    private static func calculateDaysInTheMonth(year: Int, month: Int) -> Int {
        
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    
    }
    
    
}

