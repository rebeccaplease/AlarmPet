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
    var childViewController: GhostViewController?
    //var mainView: MainView?
    //MARK: State
    
    var ghostArray:[ (ghost: Ghost, imageView: UIImageView, timer: NSTimer) ]? = nil
    
    enum State: String, Printable {
        case Defend = "Defend" //alarm going off
        case Play = "Play"
        case Win = "Win"
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    var currentState: State = .Play {
        /* didSet {
        switch(currentState) {
        case .Win:
        currentState = .Play
        default:
        println("default")
        }
        }
        */
        
        didSet {
            switch(currentState) {
            case .Win:
                //displayWinAlert()
                currentState  = .Play
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
            
           // var petPosition =  mainView.petImageView.frame.origin
            //println("\(petPosition)")
            
            //StateMachine.updateRealmPet(x: petPosition.x, y: petPosition.y)
        }
        else {
            pet = Pet()
            StateMachine.saveRealmPet(pet!)
        }
        
        
        let mainView = self.view as! MainView
        //mainView = self.view as? MainView
        //if let mainView = mainView {
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
            //if no alarm is set yet
        else {
            //mainView.toggleAlarm.selected = true
            
            //hide alarm time and toggle button
            mainView.alarmTime.hidden = true
            mainView.toggleAlarm.hidden = true
            alarm = Alarm()
            StateMachine.saveRealmAlarm(alarm!)
        }
        
        //mainView.winLabel.hidden = true
        
        StateMachine.checkState(&currentState)
        switch currentState {
        case .Defend:
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            println("Defending")
            //Ghost.createGhosts(self, ghostCount: Ghost.getGhostCount())
            //Ghost.createGhosts(self)
            childViewController!.createGhosts()
            
            //Ghost.createGhosts(self.window!.visibleViewController()!, ghostCount: StateMachine.getRealmState()!.remainingGhosts)
            
            //update pet health
            
        case .Play:
            //Ghost.updateGhostArray(nil)
            
            childViewController!.updateGhostArray(nil)            //Ghost.updateGhostArray(nil)
            
            println("Playing")
        default:
            println("Default")
        }
        
        
        //let tap = childViewController!.gestureRecognizers![0] as! UITapGestureRecognizer
        //tap.addTarget(self, action: "tappedScreen:")
        
     
        /*
        //bind label and button to Alarm?
        
        // AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        */
    }
    
//    func tappedScreen(recognizer: UITapGestureRecognizer) {
//        
//        let mainView = self.view as! MainView
//        println("tappedScreen")
//        if mainView.winLabel.hidden == false {
//            mainView.winLabel.hidden = true
//        }
//        
//    }
    
//    func createGhosts() {
//        
//        let mainView = self.view as! MainView
//        Ghost.createGhosts()
//        for (index, element) in enumerate(Ghost.ghostArray!){
//            mainView.addSubview(element.imageView)
//            //ghostArray![index].imageView
//        }
//        
//        Ghost.delegate = self
//        
//    }
    
    //called every time view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("View Will Appear")
        
        switch currentState {
        case .Defend:
            println("Defending")
            //Ghost.createGhosts(self, ghostCount: Ghost.getGhostCount())
            //Ghost.createGhosts(self)
        case .Play:
            //Ghost.updateGhostArray(nil)
            println("Playing")
        default:
            println("Default")
        }
    }
    
    
    //MARK: Toggle Alarm
    @IBAction func alarmToggle(sender: AnyObject) {
        
        let mainView = self.view as! MainView
        //if(!mainView.alarm.isSet) {
        if let alarm = alarm {
            if(!alarm.isSet) {
                StateMachine.updateRealmAlarm(time: alarm.time, isSet: true)
                
                self.alarm = StateMachine.getRealmAlarm()
                mainView.alarmTime.hidden = false
                mainView.toggleAlarm.selected = false
                
                NotificationHelper.handleScheduling(alarm.time, numOfNotifications: 3, delayInSeconds: 0, alarm: alarm)
                
                mainView.alarmTime.text = dateFormatter.stringFromDate(alarm.time)
                
            }
            else {
                
                StateMachine.updateRealmAlarm(time: alarm.time, isSet: false)
                
                self.alarm = StateMachine.getRealmAlarm()
                mainView.alarmTime.hidden = true
                mainView.toggleAlarm.selected = true
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                
            }
        }
    }
    
    func displayDefendAlert() {
        
        let alertController = UIAlertController(title: "Alert!", message: "Defend your pet from harm!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new View Controller using segue.destinationViewController.
        // Pass the selected object to the new View Controller.
        println("prepareForSegue")
        if segue.identifier == "presentAlarm" {
        let alarmViewController = segue.destinationViewController as! AlarmViewController
        //let mainView = self.view as! MainView
        //pass alarm to alarmViewController
        alarmViewController.alarm = alarm
        }
        else if segue.identifier == "showPetAndGhosts" {
            childViewController = segue.destinationViewController as? GhostViewController
        }
        
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        println("unwinding")
        
        let mainView = self.view as! MainView
        let alarmVC = segue.sourceViewController as! AlarmViewController
        
        if (segue.identifier == "Save") {
            
            alarm = alarmVC.alarm
            
            mainView.toggleAlarm.selected = false
            mainView.alarmTime.hidden = false
            mainView.toggleAlarm.hidden = false
            
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
