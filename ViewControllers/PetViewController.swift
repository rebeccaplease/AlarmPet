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
    var mainView: MainView?
    
    @IBOutlet weak var instructionLabel: UILabel!
    var brightness: Double = 0
    //MARK: State
    
    @IBOutlet weak var affectionLabel: UIButton!
    
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
        
        didSet {
            switch(currentState) {
            case .Win:
                //displayWinAlert()
                currentState  = .Play
            case .Defend:
                
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "increaseBrightness:", userInfo: nil, repeats: true)
                
            default:
                println("default")
            }
        }
        
    }
    
    func increaseBrightness(timer: NSTimer) {
        brightness += 0.05
        UIScreen.mainScreen().brightness = CGFloat(brightness)
        if brightness >= 1.0 {
            timer.invalidate()
        }
    }
    
    
    //MARK: View Loading
    
    override func viewDidLoad() {
        
        //print realm objects**
        
        RealmHelper.printAllRealmObjects()
        //RealmHelper.deleteRealmObjects()
        
        pet = RealmHelper.getRealmPet()
        alarm = RealmHelper.getRealmAlarm()
        
        super.viewDidLoad()
        
        println("View Did Load")
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        mainView = self.view as? MainView
        if let pet = pet {
            //let mainView = self.view as! MainView
            
            // var petPosition =  mainView.petImageView.frame.origin
            //println("\(petPosition)")
            
            //RealmHelper.updateRealmPet(x: petPosition.x, y: petPosition.y)
        }
        else {
            pet = Pet()
            RealmHelper.saveRealmPet(pet!)
            
        }
        
        if let mainView = mainView {
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
                instructionLabel.hidden = true
            }
                //if no alarm is set yet
            else {
                //mainView.toggleAlarm.selected = true
                
                //hide alarm time and toggle button
                mainView.alarmTime.hidden = true
                mainView.toggleAlarm.hidden = true
                alarm = Alarm()
                RealmHelper.saveRealmAlarm(alarm!)
                instructionLabel.hidden = false
            }
            affectionLabel.setTitle("\(pet!.affection)", forState: UIControlState.Normal)
        }
        
        //mainView.winLabel.hidden = true
        
        RealmHelper.checkState(&currentState)
        switch currentState {
        case .Defend:
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            println("Defending")
            childViewController!.createGhosts()
         
            //update pet health
            
        case .Play:
            
            childViewController!.updateGhostArray(nil)
            
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
                RealmHelper.updateRealmAlarm(time: alarm.time, isSet: true)
                
                self.alarm = RealmHelper.getRealmAlarm()
                //mainView.alarmTime.hidden = false
                mainView.alarmTime.textColor = UIColor.whiteColor()
                mainView.toggleAlarm.selected = false
                
                NotificationHelper.handleScheduling(alarm.time, numOfNotifications: 3, delayInSeconds: 0, alarm: alarm)
                
                mainView.alarmTime.text = dateFormatter.stringFromDate(alarm.time)
                
            }
            else {
                
                RealmHelper.updateRealmAlarm(time: alarm.time, isSet: false)
                
                self.alarm = RealmHelper.getRealmAlarm()
                //mainView.alarmTime.hidden = true
                mainView.alarmTime.textColor = UIColor.grayColor()
                mainView.toggleAlarm.selected = true
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                
            }
        }
    }
    
    func displayDefendAlert() {
        
        let alertController = UIAlertController(title: "Alert!", message: "Defend your pet from harm!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new View Controller using segue.destinationViewController.
        // Pass the selected object to the new View Controller.
        println("prepareForSegue")
        
        if segue.identifier == "presentAlarm" {
            let alarmViewController = segue.destinationViewController as! AlarmViewController
            
            //pass alarm to alarmViewController
            alarmViewController.alarm = alarm
        }
        else if segue.identifier == "showPetAndGhosts" {
            childViewController = segue.destinationViewController as? GhostViewController
            childViewController!.petVC = self
            println("\(childViewController)")
            
        }
        else if segue.identifier == "about" {
            // let aboutVC = segue.destinationViewController as! AboutViewController
        }
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        println("unwinding")
        
        let mainView = self.view as! MainView
        
        
        if (segue.identifier == "Save") {
            let alarmVC = segue.sourceViewController as! AlarmViewController
            alarm = alarmVC.alarm
            
            instructionLabel.hidden = true
            
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
