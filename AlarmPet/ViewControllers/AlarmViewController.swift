//
//  AlarmViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/10/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    //var saveAlarmTime: NSDate = NSDate()
    
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
        //saveAlarmTime = datePicker.date
        
        savedTime.text = AlarmViewController.dateFormatter.stringFromDate(datePicker.date)
        
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

