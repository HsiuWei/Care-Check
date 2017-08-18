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
        
        //set bar button color
        UINavigationBar.appearance().tintColor = UIColor.customDarkGray
        
        //set background fetch interval
        backGroundFetch()
        
        //firebase configuration required
        FirebaseApp.configure()
        
        //if the Value of key UDkeys.uuid.key has been set, then enter medicine user main screen: MedListViewController
        if UserDefaults.standard.object(forKey: UDkeys.uuid.key) != nil {
            
            //set rootViewController as MedListViewController's navigation Controller
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "newMainScreenID") as! UINavigationController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            //set delegate as self, locale notification functions required
            UNUserNotificationCenter.current().delegate = self
            
            //for tutorial message function, if the user has entered once then don't show the tutorial
            UserDefaults.standard.set(false, forKey: UDkeys.tutorialMessageFlag.tutorialMessageFlagkey)
        }
    
        //if UDkeys.careTakerUuid.careTakerUuidkey 's value is set, then the user should enter care taker main screen every time they open the app
        else if (UserDefaults.standard.stringArray(forKey: UDkeys.careTakerUuid.careTakerUuidkey)?.isEmpty == false) && (UserDefaults.standard.stringArray(forKey: UDkeys.patientName.patientNamekey)?.isEmpty == false) {
        
            //set rootViewController as CTHomeViewController's navigation Controller
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControllerOne : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ctMainID") as! UINavigationController
            self.window?.rootViewController = initialViewControllerOne
            self.window?.makeKeyAndVisible()

            //for locale notification function
            UNUserNotificationCenter.current().delegate = self
            
            //for tutorial message
            UserDefaults.standard.set(false, forKey: UDkeys.tutorialMessageFlag.tutorialMessageFlagkey)
        }
            
        //user first enter this app
        else {
           //do nothing because this means it's the first time running the app,and we need to ask for user to allow us to send notification
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
               //call back function after the user chose either allow or deny!!!
                print("ggggrrrraaaannnnntttttt")
            }
          
            //set the delegate of the UNUserNotificationCenter as this view controller
            UNUserNotificationCenter.current().delegate = self
            
            //set tutorial message flag as true because the user first enter this app
            UserDefaults.standard.set(true, forKey: UDkeys.tutorialMessageFlag.tutorialMessageFlagkey)
        }
        
        return true
    }
    
    //the notification can pop out both in front and background modes
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }

    //when a notification is tapped
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
        //"Taken!" button tapped
        if response.actionIdentifier == "doneOptionID" {
           
            //get the notification id of this notification that is tapped "Taken!"
            let tappedIdentifier = response.notification.request.identifier
            doneNotificationOfMeds.append(tappedIdentifier)
            
            //store the ids into UserDefaults
            UserDefaults.standard.set(doneNotificationOfMeds, forKey: UDkeys.doneNotificationIds.doneNotificationIdskey)
        }
        
        //last step after tapping the options, we need to execute the completionHandler function
        completionHandler()
        
    }
    
    //set backGroundFetch interval as minimum
    func backGroundFetch() {
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    
    }
    
    //once the backGroundFetch is called, run the viewWillAppear function in MedListViewController
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let medListVC = (window?.rootViewController as? UINavigationController)?.topViewController as? MedListViewController {
            
            //in order to call the schedule for today function
            medListVC.viewWillAppear(true)
        }
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

