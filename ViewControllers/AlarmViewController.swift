//
//  AlarmViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/10/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit


class AlarmViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var alarm: Alarm?
    
    var pickerData: [String] = ["ShipBell", "funky", "test2"]
    //MARK: Date functions
    
    @IBOutlet weak var soundPicker: UIPickerView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        //set default seconds to zero
        //if time is before today, set to next day
        //on and off alarms
        
        var soundNumber = soundPicker.selectedRowInComponent(0)
        var sound = pickerData[soundPicker.selectedRowInComponent(0)]
        
        //set default vaule for sound preferences
        NSUserDefaults.standardUserDefaults().setObject(sound, forKey: "defaultSound")
        NSUserDefaults.standardUserDefaults().setObject(soundNumber, forKey: "defaultSoundNumber")
        
        println("saveButtonPressed")
        if let newAlarm = alarm{
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            NotificationHelper.handleScheduling(datePicker.date, numOfNotifications: 3, delayInSeconds: 0, soundName: sound)
            RealmHelper.updateRealmAlarm(time: newAlarm.time, isSet: true)
            RealmHelper.updateRealmAlarmDidWin(false)
            //fix this for runtime
            alarm = RealmHelper.getRealmAlarm()
        }
        else {
            let a = Alarm()
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            NotificationHelper.handleScheduling(datePicker.date, numOfNotifications: 3, delayInSeconds: 0, soundName: sound)
            RealmHelper.saveRealmAlarm(a)
            alarm = RealmHelper.getRealmAlarm()
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
        //set to display times
        datePicker.datePickerMode = UIDatePickerMode.Time
        
        
        self.soundPicker.delegate = self
        self.soundPicker.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentDate = NSDate()
        //default to current time
        datePicker.date = currentDate
        
        //returns zero if none saved
        var soundNumber = NSUserDefaults.standardUserDefaults().integerForKey("defaultSoundNumber")
            soundPicker.selectRow(soundNumber, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension AlarmViewController: UIPickerViewDelegate {
    
}

extension AlarmViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
}
