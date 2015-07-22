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
    let alarm = Alarm.sharedInstance
    
    //when app is closed/in background, check for launch from push notification
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //if launchOptions is not nil (starting from a push notif), then open PetViewControler
        if let launchOptions = launchOptions {
            println("launchOptions")
            //also check specifially for local notifications?
            //if let notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] as? [NSObject : AnyObject] {
            //setPetView()
            //}
        }
        else {
            println("not coming from push")
            NotificationHelper.registerNotification(application)
        }
        
        alarm.checkState()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        println("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        println("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        println("applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        alarm.checkState()
        println("applicationDidBecomeActive")
    }
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        println("applicationWillTerminate")
    }
    
    //if app is open and notification is recieved, open PetViewController
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {

    }
    
    //if a custom notification action is chosen from push notification (from swiping left)
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        println("handleActionWithIdentifier")
        
        if let identifier = identifier {
            switch identifier {
            case "SNOOZE":
                //dismiss upcoming local notifications
                //create another set of notifications
                //play them in 2 minutes from the current time
                application.cancelAllLocalNotifications()
                
                println("zzzz snoozing")
                
                NotificationHelper.handleScheduling(NSDate(), numOfNotifications: 3, delayInSeconds: 120)
            default: //for DEFEND
                application.cancelAllLocalNotifications()
                alarm.checkState()
                println("defense")
            }
        }
        completionHandler()
    }
}