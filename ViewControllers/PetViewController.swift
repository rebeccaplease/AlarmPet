//
//  PetViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/14/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit
//import AVFoundation

class PetViewController: UIViewController {
    
    //let ghost = Ghost.sharedInstance
    //let pet: Pet? = StateMachine.getRealmPet()
    //var pet: Pet? = self.getPet()
    
    var state: StateMachine.State = StateMachine.currentState {
        didSet {
            switch(state) {
            case .Win:
            
            state = .Play
            default:
            println("default")
            }
        }
    }
    
    //MARK: View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("View Did Load")
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        StateMachine.checkState()
        switch StateMachine.currentState {
        case .Defend:
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            println("Defending")
            Ghost.createGhosts(self)
            //Ghost.move(pet!.x, pet.y)
        case .Play:
            Ghost.updateGhostArray(nil)
            println("Playing")
        default:
            println("Default")
        }
        /*
        //bind label and button to Alarm?
        
        // AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        */
    }
    
    //called every time view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("View Will Appear")
        
        switch StateMachine.currentState {
        case .Defend:
            println("Defending")
            Ghost.createGhosts(self)
        case .Play:
            Ghost.updateGhostArray(nil)
            println("Playing")
        default:
            println("Default")
        }
        
    }
    //move ghosts
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        println("View Did Appear")
        
        
        switch StateMachine.currentState {
        case .Defend:
            //Ghost.move(pet!.x, pet.y)
            println("Defending")
        case .Play:
            Ghost.updateGhostArray(nil)
            println("Playing")
        default:
            println("Default")
        }
        
        
    }
    
    //MARK: Toggle Alarm
    @IBAction func alarmToggle(sender: AnyObject) {
        
        let mainView = self.view as! MainView
        if(!mainView.alarm.isSet) {
            
            StateMachine.updateRealmAlarm(mainView.alarm, time: mainView.alarm.time, isSet: true)
            
            mainView.alarmTime.hidden = false
            mainView.toggleAlarm.selected = false
            
            NotificationHelper.handleScheduling(mainView.alarm.time, numOfNotifications: 3, delayInSeconds: 0, alarm: mainView.alarm)
            
            mainView.alarmTime.text = mainView.dateFormatter.stringFromDate(mainView.alarm.time)
            
        }
        else {
            
            StateMachine.updateRealmAlarm(mainView.alarm, time: mainView.alarm.time, isSet: true)
            
            
            mainView.alarmTime.hidden = true
            mainView.toggleAlarm.selected = true
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new View Controller using segue.destinationViewController.
        // Pass the selected object to the new View Controller.
        println("prepareForSegue")
        
        let alarmViewController = segue.destinationViewController as! AlarmViewController
        let mainView = self.view as! MainView
        //pass alarm to alarmViewController
        alarmViewController.oldAlarm = mainView.alarm
        
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        println("unwinding")
        //update labels
        let mainView = self.view as! MainView
        if segue.identifier == "Save" {
            let alarmViewController = segue.sourceViewController as! AlarmViewController
            let mainView = self.view as! MainView
            //set new alarm from alarmViewController
            mainView.alarm = alarmViewController.newAlarm
            
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            NotificationHelper.handleScheduling(alarmViewController.datePicker.date, numOfNotifications: 3, delayInSeconds: 0, alarm: alarmViewController.newAlarm)
            StateMachine.deleteRealmAlarm()
            StateMachine.saveRealmAlarm(alarmViewController.newAlarm)
        }
        
        if (UIApplication.sharedApplication().scheduledLocalNotifications.count == 0) {
            mainView.toggleAlarm.selected = true
            mainView.alarmTime.hidden = true
            println("no notifications")
        }
        else {
            mainView.toggleAlarm.selected = false
            mainView.alarmTime.hidden = false
            
            let mainView = self.view as! MainView
            mainView.alarmTime.text = mainView.dateFormatter.stringFromDate(mainView.alarm.time)
            println("alarm set!")
        }
        //self.view.setNeedsDisplay()
    }
    
}
