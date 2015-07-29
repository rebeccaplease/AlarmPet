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
    
    //let pet: Pet = StateMachine.getRealmPet()!
    
    //when app is closed/in background, check for launch from push notification
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //if launchOptions is not nil (starting from a push notif), then open PetViewControler
        
        application.cancelAllLocalNotifications()
        if let launchOptions = launchOptions {
            println("launchOptions")
        }
        else {
            println("not coming from push")
            NotificationHelper.registerNotification(application)
        }
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
        println("applicationDidBecomeActive")
        
        StateMachine.checkState()
        switch StateMachine.currentState {
        case .Defend:
            application.cancelAllLocalNotifications()
            println("Defending")
            
            
            //Ghost.createGhosts(self.window!.rootViewController)
            Ghost.createGhosts(self.window!.visibleViewController()!)
            
        case .Play:
            Ghost.updateGhostArray(nil)
            println("Playing")
            
        default:
            println("Default")
        }
        
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
                //**load alarm from here
                if let alarm = StateMachine.getRealmAlarm() {
                    NotificationHelper.handleScheduling(NSDate(), numOfNotifications: 3, delayInSeconds: 120, alarm: alarm)
                }
            default: //for DEFEND
                println("defend")
                /*application.cancelAllLocalNotifications()
                
                StateMachine.checkState()
                switch StateMachine.currentState {
                case .Defend:
                    application.cancelAllLocalNotifications()
                    println("Defending")
                    Ghost.createGhosts(self.window!.rootViewController!)
                
                case .Play:
                    Ghost.updateGhostArray(nil)
                    println("Playing")
                
                default:
                    println("Default")

                } */
            }
        }
        completionHandler()
    }
}

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKindOfClass(UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController)
        }
            
        else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(presentedViewController.presentedViewController!)
                
            } else {
                
                return vc;
            }
        }
    }
}
