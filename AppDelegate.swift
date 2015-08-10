//
//  AppDelegate.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/10/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var petViewController: PetViewController?
    
    //when app is closed/in background, check for launch from push notification
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        println("didFinishLaunchingWithOptions")
        
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        // Notice setSchemaVersion is set to 1, this is always set manually. It must be
        // higher than the previous version (oldSchemaVersion) or an RLMException is thrown
        setSchemaVersion(3, Realm.defaultPath, { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if oldSchemaVersion < 3 {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        })
        // now that we have called `setSchemaVersion(_:_:_:)`, opening an outdated
        // Realm will automatically perform the migration and opening the Realm will succeed
        // i.e. Realm()
        
        //application.cancelAllLocalNotifications()
        
        
        if let launchOptions = launchOptions {
            println("launchOptions")
        }
        else {
            println("not coming from push notification")
            
            NotificationHelper.registerNotification(application) //have user register notifications (add a previous uialert and move somewhere else)
        }
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        println("applicationDidBecomeActive")
        
        //let petVC = self.window!.visibleViewController()! as! PetViewController
        if let petViewController = petViewController {
            
        }
        else {
            self.petViewController = self.window!.visibleViewController()! as? PetViewController
        }
        
        RealmHelper.checkState(&petViewController!.childViewController!.currentState)
        
        switch petViewController!.childViewController!.currentState {
        case .Defend:
            application.cancelAllLocalNotifications()
            println("Defending")
            
            petViewController!.childViewController!.updatePetHealth()
            petViewController!.childViewController!.createGhosts()
            
            //update pet health
            
        case .Play:
            
            petViewController!.childViewController!.updateGhostArray(nil)
            println("Playing")
            
        default:
            println("Default")
        }
        
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
        
        if let state = RealmHelper.getRealmState() {
            
            //RealmHelper.updateRealmStateAndGhosts(gameState: state.state)
            RealmHelper.updateRealmState(state.state)
            
        }
        else {
            var saveState = SaveState()
            
            saveState.state = petViewController!.childViewController!.currentState.description
            
            RealmHelper.saveRealmState(saveState)
        }
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        println("applicationWillEnterForeground")
    }
    
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        println("applicationWillTerminate")
        //let petVC = self.window!.visibleViewController()! as! PetViewController
        
        if let state = RealmHelper.getRealmState() {
            
            RealmHelper.updateRealmState(state.state)
            
        }
        else {
            var saveState = SaveState()
            
            saveState.state = petViewController!.childViewController!.currentState.description
            
            RealmHelper.saveRealmState(saveState)
        }
    }
    
    //if app is open and notification is recieved
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        println("didReceiveLocalNotification")
        
        application.cancelAllLocalNotifications()
        
        RealmHelper.checkState(&petViewController!.childViewController!.currentState)
        switch petViewController!.childViewController!.currentState {
        case .Defend:
            application.cancelAllLocalNotifications()
            println("Defending")
            petViewController!.childViewController!.createGhosts()
            
            //petVC.displayDefendAlert()
            
            //update pet health
            
        case .Play:
            
            petViewController!.childViewController!.updateGhostArray(nil)
            println("Playing")
            
        default:
            println("Default")
            
        }
        
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
                if let alarm = RealmHelper.getRealmAlarm() {
                    
                    if let sound = NSUserDefaults.standardUserDefaults().stringForKey("defaultSound") {
                        NotificationHelper.handleScheduling(NSDate(), numOfNotifications: 3, delayInSeconds: 120, soundName: sound)
                    }
                    else {
                        NotificationHelper.handleScheduling(NSDate(), numOfNotifications: 3, delayInSeconds: 120, soundName: "ShipBell")
                    }
                }
            default: //for DEFEND
                println("defend")
                
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
