//
//  NotificationHelper.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/15/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit

class NotificationHelper {
    
    //schedule one notification with ID and alarm time
    static func scheduleNotification(#id: Int, alarm: NSDate){
        println(alarm)
        
        var notification = UILocalNotification()
        
        //when notif will appear
        notification.fireDate = alarm
        notification.timeZone  = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Virtual pet in danger!"
        notification.alertAction = "open"
        //notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.soundName = "ShipBell.wav"
        notification.category = "CATEGORY"
        
        //notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    //zero seconds and schedule number of notifications
    static func handleScheduling(dateToFix: NSDate, numOfNotifications: Int, delayInSeconds: Int) {
        var dateComponents: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute, fromDate: dateToFix)
        
        //check current day and time. if the time today already passed, set alarm for next day
        let currentTime = NSDate()
        if currentTime.isEqualToDate(currentTime.laterDate(dateToFix)) {
            dateComponents.day += 1
            println("Set for next day")
        }
        //normally zero. if snoozing - some value
        dateComponents.second = delayInSeconds
        
        var fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        //zero seconds
        var saveAlarmTime = fixedDate
        
        for index in 1...numOfNotifications {
            //loop and schedule numOfNotifications notifications, 30 seconds apart
            
            scheduleNotification(id: index, alarm: fixedDate)
            
            dateComponents.second = 30*index
            fixedDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        }
        //return saveAlarmTime
    }
    
    //set up custom notification buttons and register user settings permission (if first launch)
    static func registerNotification(application: UIApplication) {
        
        let openAction = UIMutableUserNotificationAction()
        openAction.identifier = "DEFEND" // the unique identifier for this action
        openAction.title = "Defend" // title for the action button
        //openAction.activationMode = .Background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        openAction.authenticationRequired = true // don't require unlocking before performing action
        openAction.destructive = false // display action in blue
        openAction.activationMode = UIUserNotificationActivationMode.Foreground //launch app
        
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "SNOOZE" // the unique identifier for this action
        snoozeAction.title = "Snooze" // title for the action button
        snoozeAction.authenticationRequired = false // don't require unlocking before performing action
        snoozeAction.destructive = false // display action in red
        snoozeAction.activationMode = UIUserNotificationActivationMode.Background //don't launch app
        
        
        let optionsCategory = UIMutableUserNotificationCategory() // notification categories allow us to create groups of actions that we can associate with a notification
        optionsCategory.identifier = "CATEGORY"
        optionsCategory.setActions([snoozeAction, openAction], forContext: UIUserNotificationActionContext.Default) // UIUserNotificationActionContext.Default (4 actions max)
        optionsCategory.setActions([snoozeAction, openAction], forContext: UIUserNotificationActionContext.Minimal) // UIUserNotificationActionContext.Minimal - for when space is limited (2 actions max)
        
        
        
        var categories = Set([optionsCategory])
        
        //register for local notifications. ask for user permission (move later)
        var requestedTypes: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: requestedTypes, categories: categories )
        
        application.registerUserNotificationSettings(settings)
    }
}