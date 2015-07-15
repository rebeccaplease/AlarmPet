//
//  AppDelegate.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/10/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //when app is closed/in background, check for launch from push notification
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //if launchOptions is not nil (starting from a push notif), then open PetViewControler
        if let launchOptions = launchOptions {
            println("launchOptions")
            //also check specifially for local notifications?
            //if let notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] as? [NSObject : AnyObject] {
                setPetView()
            //}
        }
        else {
            println("not coming from push")
            registerNotification(application)
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    }
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //if app is open and notification is recieved, open PetViewController
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
      
        setPetView()
    }
    
    //if a custom button is chosen from push notification (from swiping left)
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        /*if identifier.equals("SNOOZE") {
        //dismiss upcoming local notifications
        //create another set of notifications
        //play them in 10 minutes
        }
        else { //for DEFEND
        setPetView()
        }
        */
        println("custom button pressed")
        setPetView()
        completionHandler()
    }
    
    //set up custom notification buttons and register user settings permission (if first launch)
    func registerNotification(application: UIApplication) {
        
        let openAction = UIMutableUserNotificationAction()
        openAction.identifier = "DEFEND" // the unique identifier for this action
        openAction.title = "Defend" // title for the action button
        //openAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        openAction.authenticationRequired = false // don't require unlocking before performing action
        openAction.destructive = false // display action in blue
        openAction.activationMode = UIUserNotificationActivationMode.Foreground
        
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "SNOOZE" // the unique identifier for this action
        snoozeAction.title = "Snooze" // title for the action button
        //openAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        snoozeAction.authenticationRequired = false // don't require unlocking before performing action
        snoozeAction.destructive = true // display action in red
        snoozeAction.activationMode = UIUserNotificationActivationMode.Background
        
        
        let optionsCategory = UIMutableUserNotificationCategory() // notification categories allow us to create groups of actions that we can associate with a notification
        optionsCategory.identifier = "CATEGORY"
        optionsCategory.setActions([snoozeAction, openAction], forContext: UIUserNotificationActionContext.Default) // UIUserNotificationActionContext.Default (4 actions max)
        optionsCategory.setActions([snoozeAction, openAction], forContext: UIUserNotificationActionContext.Minimal) // UIUserNotificationActionContext.Minimal - for when space is limited (2 actions max)
        
        var categories = Set([optionsCategory])
        
        //register for local notifications. ask for user permission (move later)
        var types: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories )
        
        application.registerUserNotificationSettings(settings)
    }
    
    //open view to PetViewController
    func setPetView () {
        var rootViewController = self.window!.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var petViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PetViewController") as! PetViewController
      
        rootViewController?.presentViewController(petViewController, animated: true, completion: nil)
    }
}

