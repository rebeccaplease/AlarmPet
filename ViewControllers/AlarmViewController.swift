//
//  AlarmViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/10/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    var saveAlarmTime: NSDate = NSDate()
    
    //The date and time when the system should deliver the notification.
    //@NSCopying var fireDate: NSDate?
    
    
    //MARK: Date functions
    @IBOutlet weak var sunday: UIButton!
    @IBOutlet weak var monday: UIButton!
 
    @IBOutlet weak var tuesday: UIButton!
    @IBOutlet weak var wednesday: UIButton!
    @IBOutlet weak var thursday: UIButton!
    @IBOutlet weak var friday: UIButton!
    @IBOutlet weak var saturday: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var savedTime: UILabel!
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        //set default seconds to zero
        //if time is before today, set to next day
        //on and off alarms
    
     //   var seconds = Double( NSDateComponents().second )
        
       // saveAlarmTime = datePicker.date.dateByAddingTimeInterval(-seconds)
        
        saveAlarmTime = datePicker.date
        
        savedTime.text = AlarmViewController.dateFormatter.stringFromDate(saveAlarmTime)
        
        //loop and schedule 5 notifications, 30 seconds each
        scheduleNotification(id: 1)
    }
    
    func scheduleNotification(#id: Int){
        println(saveAlarmTime)
        
        var notification = UILocalNotification()
        
        //when notif will appear
        notification.fireDate = saveAlarmTime
        notification.timeZone  = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Virtual pet in danger!"
        notification.alertAction = "open"
        //notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.soundName = "Assets/ShipBell.wav"
        notification.category = "CATEGORY"
        
        //notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return formatter
        }()
    
    
    //MARK: View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //set to display times
        datePicker.datePickerMode = UIDatePickerMode.Time
        let currentDate = NSDate()
        //default to current time
        datePicker.date = currentDate
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

