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
        
    
     //   var seconds = Double( NSDateComponents().second )
        
       // saveAlarmTime = datePicker.date.dateByAddingTimeInterval(-seconds)
        
        saveAlarmTime = datePicker.date
        
        savedTime.text = AlarmViewController.dateFormatter.stringFromDate(saveAlarmTime)
        
        scheduleNotification()
    }
    
    func scheduleNotification(){
        println(saveAlarmTime)
        
        /*
        
        var notification = UILocalNotification()
        notification.alertBody = "Todo Item \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
*/
        var notification = UILocalNotification()
        notification.fireDate = saveAlarmTime
        notification.timeZone  = NSTimeZone.defaultTimeZone()
        notification.alertBody = "Virtual pet in danger!"
        notification.alertAction = "open"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.category = "CATEGORY"
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return formatter
        }()
    
    //@IBAction func saveDayOfWeek(sender: AnyObject) {
      //  if
    //}
    
    //MARK: View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //set to display times
        datePicker.datePickerMode = UIDatePickerMode.Time
        let currentDate = NSDate()
        //default to current time
        datePicker.date = currentDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

