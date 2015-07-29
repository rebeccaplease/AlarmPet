//
//  AlarmViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/10/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    var alarm: Alarm? = StateMachine.getRealmAlarm()

    //MARK: Date functions
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        //set default seconds to zero
        //if time is before today, set to next day
        //on and off alarms
        /*
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        NotificationHelper.handleScheduling(datePicker.date, numOfNotifications: 3, delayInSeconds: 0, alarm: newAlarm)
        StateMachine.deleteRealmAlarm()
        StateMachine.saveRealmAlarm(newAlarm)
        */
        if let newAlarm = alarm{
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            NotificationHelper.handleScheduling(datePicker.date, numOfNotifications: 3, delayInSeconds: 0, alarm: newAlarm)
            StateMachine.updateRealmAlarm(time: newAlarm.time, isSet: true)
            alarm = StateMachine.getRealmAlarm()
        }
        else {
            let a = Alarm()
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            NotificationHelper.handleScheduling(datePicker.date, numOfNotifications: 3, delayInSeconds: 0, alarm: a)
            StateMachine.saveRealmAlarm(a)
            alarm = StateMachine.getRealmAlarm()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cancelUnwindSegue(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoadAlarm")
        // Do any additional setup after loading the view, typically from a nib.
        //set to display times
        datePicker.datePickerMode = UIDatePickerMode.Time
        let currentDate = NSDate()
        //default to current time
        datePicker.date = currentDate
        
        // navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

