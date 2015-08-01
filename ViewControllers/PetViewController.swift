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
    
    var pet: Pet?
    var alarm: Alarm?
    
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
        
        //print realm objects**
        
        StateMachine.printAllRealmObjects()
        //StateMachine.deleteRealmObjects()
        
        pet = StateMachine.getRealmPet()
        alarm = StateMachine.getRealmAlarm()
        
        super.viewDidLoad()
        
        println("View Did Load")
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let pet = pet {
            let mainView = self.view as! MainView
            
            var petPosition =  mainView.petImageView.frame.origin
            println("\(petPosition)")
            
            StateMachine.updateRealmPet(x: petPosition.x, y: petPosition.y)
        }
        else {
            pet = Pet()
            StateMachine.saveRealmPet(pet!)
        }
        
        
        let mainView = self.view as! MainView
        if let alarm = alarm{
            if (alarm.isSet) {
                mainView.toggleAlarm.selected = false
                mainView.alarmTime.hidden = false
                mainView.alarmTime.text = dateFormatter.stringFromDate(alarm.time)
            }
            else {
                mainView.toggleAlarm.selected = true
                mainView.alarmTime.hidden = true
            }
        }
        else {
            
            mainView.toggleAlarm.selected = true
            mainView.alarmTime.hidden = true
            alarm = Alarm()
            StateMachine.saveRealmAlarm(alarm!)
        }
        
        mainView.winLabel.hidden = true
        
        StateMachine.checkState()
        switch StateMachine.currentState {
        case .Defend:
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            println("Defending")
            //Ghost.createGhosts(self, ghostCount: Ghost.getGhostCount())
            Ghost.createGhosts(self)
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
            //Ghost.createGhosts(self, ghostCount: Ghost.getGhostCount())
            Ghost.createGhosts(self)
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
        //if(!mainView.alarm.isSet) {
        
        if(!alarm!.isSet) {
            StateMachine.updateRealmAlarm(time: alarm!.time, isSet: true)
            
            alarm = StateMachine.getRealmAlarm()!
            mainView.alarmTime.hidden = false
            mainView.toggleAlarm.selected = false
            
            NotificationHelper.handleScheduling(alarm!.time, numOfNotifications: 3, delayInSeconds: 0, alarm: alarm!)
            
            mainView.alarmTime.text = dateFormatter.stringFromDate(alarm!.time)
            
        }
        else {
            
            StateMachine.updateRealmAlarm(time: alarm!.time, isSet: false)
            
            alarm = StateMachine.getRealmAlarm()!
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
        //let mainView = self.view as! MainView
        //pass alarm to alarmViewController
        alarmViewController.alarm = alarm
        
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        println("unwinding")
        
        let mainView = self.view as! MainView
        let alarmVC = segue.sourceViewController as! AlarmViewController
        
        if (segue.identifier == "Save") {
            
            alarm = alarmVC.alarm
            
            mainView.toggleAlarm.selected = false
            mainView.alarmTime.hidden = false
            
            mainView.alarmTime.text = dateFormatter.stringFromDate(alarmVC.datePicker.date)
            
            println("alarm set!")
        }
    }
    var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return formatter
        }()
}
