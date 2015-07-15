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
    static func handleScheduling(dateToFix: NSDate, numOfNotifications: Int, delayInSeconds: Int) -> NSDate  {
        var dateComponents: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute, fromDate: dateToFix)
        
        dateComponents.second = 0
        
        var fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        
        //zero seconds
        var saveAlarmTime = fixedDate
        
        
        
        for index in 1...numOfNotifications {
            //loop and schedule numOfNotifications notifications, 30 seconds apart
          
            scheduleNotification(id: index, alarm: fixedDate)
            
            dateComponents.second = 30*index
            fixedDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        }
        return saveAlarmTime
    }
}