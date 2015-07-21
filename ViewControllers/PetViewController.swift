//
//  PetViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/14/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit
import AVFoundation

class PetViewController: UIViewController {
    
    @IBOutlet weak var alarmTime: UILabel!
    
    @IBOutlet weak var alarmToggle: UIButton!
    
    @IBOutlet weak var ghost: UIImageView!
    
    var ghostArray:[(Ghost, UIImageView, UIGestureRecognizer)]? = nil
    
    //var ghostImageArray: [UIImageView]? = nil
    
    //let tapRecognizer = UITapGestureRecognizer()
    var alarm = Alarm.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //bind label and button to Alarm?
        if (UIApplication.sharedApplication().scheduledLocalNotifications.count == 0) {
            alarmToggle.selected = true
            alarmTime.hidden = true
        }
        else {
            alarmToggle.selected = false
            alarmTime.hidden = false
            alarmTime.text = alarm.dateFormatter.stringFromDate(alarm.time)
        }
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)

    }
    
    //called every time view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        switch alarm.currentState {
        case Alarm.State.Defend:
            
            ghostArray = [ (Ghost, UIImageView, UIGestureRecognizer) ]()
            
            for index in 1...10 {
                //ghostArray = [Ghost]()
                //ghostArray!.append(Ghost())
                
                //ghostImageArray = [UIImageView]()
                //UIImageView
                
                var temp = [(ghost: Ghost(), imageView: UIImageView(image: UIImage(named: "Ghost.png")), gesture: UITapGestureRecognizer() as UIGestureRecognizer)]
                
                temp[0].gesture.addTarget(self, action: "tappedGhost")
                
                ghostArray! += temp
                
            }
            /*
            tapRecognizer.addTarget(self, action: "tappedGhost")
            ***ghost.addGestureRecognizer(tapRecognizer)
            ghost.userInteractionEnabled = true
            */
            
        case Alarm.State.Play:
            ghostArray = nil
            //ghostImageArray = nil
            //clear screen of ghosts
            
            println("playing")
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        switch alarm.currentState {
        case Alarm.State.Defend:
            println("defending")
        case Alarm.State.Play:
            println("playing")
        }
        
    }
    
    func tappedGhost() {
        ghost.hidden = true
        
    }
    
    @IBAction func alarmToggle(sender: AnyObject) {
        
        //alarmTime.hidden = !alarmTime.hidden
        //alarmToggle.selected = !alarmToggle.selected
        if(!alarm.isSet) {
            alarmTime.hidden = false
            alarmToggle.selected = false
            
            NotificationHelper.handleScheduling(alarm.time, numOfNotifications: 3, delayInSeconds: 0)
            alarm.isSet = true
            alarmTime.text = alarm.dateFormatter.stringFromDate(alarm.time)
        }
        else {
            alarmTime.hidden = true
            alarmToggle.selected = true
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            alarm.isSet = false
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new View Controller using segue.destinationViewController.
        // Pass the selected object to the new View Controller.
        
        /*if (segue.identifier == "Alarm") {
        
        let alarmViewController = segue.destinationViewController as! AlarmViewController
        
        } */
        /*
        var contributeViewController: UIViewController = UIViewController()
        var blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var beView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        beView.frame = self.view.bounds
        
        contributeViewController.view.frame = self.view.bounds;
        contributeViewController.view.backgroundColor = UIColor.clearColor()
        contributeViewController.view.insertSubview(beView, atIndex: 0)
        contributeViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.presentViewController(contributeViewController, animated: true, completion: nil)
        */
        
        
        
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        println("unwinding")
    }
    
}
