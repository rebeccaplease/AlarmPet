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
    
    //@IBOutlet weak var alarmTime: UILabel!
    
    //@IBOutlet weak var alarmToggle: UIButton!
    
    //@IBOutlet weak var ghost: UIImageView!
    
    //let alarm = Alarm.sharedInstance
    let ghost = Ghost.sharedInstance
    
    enum State: String, Printable {
        case Defend = "Defend" //alarm going off
        case Play = "Play"
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    var currentState: State = .Play
    
    func checkState() {
        let mainView = self.view as! MainView
        //if current time is within 30 minutes of alarm time
        if let time = mainView.alarm!.time {
            //returns time difference in seconds (negative if time is earlier than current time)
            var interval = time.timeIntervalSinceNow
            println("\(interval)")
            if (interval < 0 && interval > -30*60) {
                currentState = .Defend
            }
            else {
                currentState = .Play
            }
        }
        else {
            currentState = .Play
        }
        
        println(currentState)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("View Did Load")
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        /*
        //bind label and button to Alarm?
        if (UIApplication.sharedApplication().scheduledLocalNotifications.count == 0) {
        alarmToggle.selected = true
        alarmTime.hidden = true
        }
        else {
        alarmToggle.selected = false
        alarmTime.hidden = false
        alarmTime.text = alarm.dateFormatter.stringFromDate(alarm.time!)
        }
        
        switch alarm.currentState {
        case Alarm.State.Defend:
        println("Defending")
        ghost.updateGhostArray(DefendView.createGhosts(self))
        case Alarm.State.Play:
        ghost.updateGhostArray(nil)
        println("Playing")
        default:
        println("Default")
        }
        // AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        */
    }
    
    //called every time view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("View Will Appear")
        
        
        switch currentState {
        case .Defend:
            println("Defending")
            ghost.updateGhostArray(DefendView.createGhosts(self))
        case .Play:
            ghost.updateGhostArray(nil)
            println("Playing")
        default:
            println("Default")
        }
        
    }
    //move ghosts
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        println("View Did Appear")
        
        switch currentState {
        case .Defend:
            DefendView.move()
            println("Defending")
        case .Play:
            ghost.updateGhostArray(nil)
            println("Playing")
        default:
            println("Default")
        }
        
        
    }
    
    
    @IBAction func alarmToggle(sender: AnyObject) {
        
        //alarmTime.hidden = !alarmTime.hidden
        //alarmToggle.selected = !alarmToggle.selected
        let mainView = self.view as! MainView
        if(!mainView.alarm!.isSet) {
            mainView.alarmTime.hidden = false
            mainView.toggleAlarm.selected = false
            if let time = mainView.alarm!.time  {
                NotificationHelper.handleScheduling(mainView.alarm!.time!, numOfNotifications: 3, delayInSeconds: 0, alarm: mainView.alarm!)
                mainView.alarm!.isSet = true
                mainView.alarmTime.text = mainView.dateFormatter.stringFromDate(mainView.alarm!.time!)
            }
        }
        else {
            mainView.alarmTime.hidden = true
            mainView.toggleAlarm.selected = true
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            mainView.alarm!.isSet = false
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
        mainView.alarmTime.text = mainView.dateFormatter.stringFromDate(mainView.alarm!.time!)
        println("alarm set!")
        }
        //self.view.setNeedsDisplay()
    }
    
}
