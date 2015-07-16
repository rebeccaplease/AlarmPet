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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
    //@IBOutlet weak var savedTime: UILabel!
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        //set default seconds to zero
        //if time is before today, set to next day
        //on and off alarms
        
        NotificationHelper.handleScheduling(datePicker.date, numOfNotifications: 3, delayInSeconds: 0)
        //savedTime.text = AlarmViewController.dateFormatter.stringFromDate(saveAlarmTime)
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

