//
//  AppDelegate.swift
//  Med-Asst-1.0
//
//  Created by Hsiu-Wei Chang on 14/07/2017.
//  Copyright © 2017 Hsiu-Wei Chang. All rights reserved.
//

import UIKit
import Firebase
//for the reminder function, first import the library and second conform to the delegate
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var doneNotificationOfMeds: [String] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /*
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
         */
        
        UINavigationBar.appearance().tintColor = UIColor.customDarkGray
 
                
        
        FirebaseApp.configure()
        print("Here")
        
        //You need to check if the uuidKey exists in User Defaults.
        //If it does exist, we want it to automatically present (instantiate) itself
        //in the PTHomeVC so that PillTakerPairPC never shows up again.
        
        //Check if uuidKey is nil in User Defaults
        //If uuidKey is nil, that means it has never been set, so we want it to run like normal
        //If uuidKey does exist, we want it to automatically go to PTHomeVC

        
        if UserDefaults.standard.object(forKey: UDkeys.uuid.key) != nil {
            //If it does not equal nil, that means the uuid has been set before
            //so we want to go to PTHomeVC
            
            //reset the initial view controller as the navigation bar so that the main view controllwe and the Pair view won't show when the user open the app the second time
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "newMainScreenID") as! UINavigationController
          
            self.window?.rootViewController = initialViewControlleripad
            self.window?.makeKeyAndVisible()
            print("here")
            
            UNUserNotificationCenter.current().delegate = self
            
            UserDefaults.standard.set(false, forKey: UDkeys.tutorialMessageFlag.tutorialMessageFlagkey)
            
        }
        //else if (UserDefaults.standard.stringArray(forKey: UDkeys.careTakerUuid.careTakerUuidkey)?[0] != nil) && (UserDefaults.standard.stringArray(forKey: UDkeys.patientName.patientNamekey)?[0] != nil) {
    
         else if (UserDefaults.standard.stringArray(forKey: UDkeys.careTakerUuid.careTakerUuidkey)?.isEmpty == false) && (UserDefaults.standard.stringArray(forKey: UDkeys.patientName.patientNamekey)?.isEmpty == false) {
        
        
            print("User defaults success!!")
            //go to CareTakerHomeViewController directly
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControllerOne : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ctMainID") as! UINavigationController
            self.window?.rootViewController = initialViewControllerOne
            self.window?.makeKeyAndVisible()

            UNUserNotificationCenter.current().delegate = self
            
            UserDefaults.standard.set(false, forKey: UDkeys.tutorialMessageFlag.tutorialMessageFlagkey)
        }
            
        else {
           //do nothing because this means it's the first time running the app,and we need to ask for user to allow us to send notification
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
               //call back function after the user chose either allow or deny!!!
            }
           // application.registerForRemoteNotifications()
            //set the delegate of the UNUserNotificationCenter as this view controller
            UNUserNotificationCenter.current().delegate = self
            
        UserDefaults.standard.set(true, forKey: UDkeys.tutorialMessageFlag.tutorialMessageFlagkey)
            
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
    
        if response.actionIdentifier == "doneOptionID" {
           
            print("done button tapped from the reminder")
            
            let tappedIdentifier = response.notification.request.identifier
            doneNotificationOfMeds.append(tappedIdentifier)
            
            UserDefaults.standard.set(doneNotificationOfMeds, forKey: UDkeys.doneNotificationIds.doneNotificationIdskey)

            
            print("tappedIdentifier = \(tappedIdentifier)")
        }
        
        else {
        }
        
        //last step after tapping the options, we need to execute the completionHandler function
        completionHandler()
        
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

