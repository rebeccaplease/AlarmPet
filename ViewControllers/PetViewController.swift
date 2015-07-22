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
    
    //@IBOutlet weak var ghost: UIImageView!
    
    var ghostArray:[(ghost: Ghost, imageView: UIImageView)]? = nil
    
    //var ghostImageArray: [UIImageView]? = nil
    
    let tapRecognizer = UITapGestureRecognizer()
    let alarm = Alarm.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("View Did Load")
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
            alarmTime.text = alarm.dateFormatter.stringFromDate(alarm.time!)
        }
        createGhosts()
        // AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
    }
    
    //called every time view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("View Will Appear")
        
        switch alarm.currentState {
        case Alarm.State.Defend:
            //if close app and open it again
            createGhosts()
        case Alarm.State.Play:
            ghostArray = nil
            //ghostImageArray = nil
            //clear screen of ghosts
            
            println("playing")
        default:
            println("default")
            
        }
    }
    //move ghosts
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("View Did Appear")
        
        switch alarm.currentState {
        case Alarm.State.Defend:
            println("defending")
        case Alarm.State.Play:
            println("playing")
        default:
            println("Default")
        }
        
    }
    /*
    func randomPosition() -> CGRect {
    
    
    return
    }
    */
    
    func createGhosts() {
        if let ghostArray = ghostArray {
            
        }
        else {
            ghostArray = []
            
            for index in 1...10 {
                
                var temp = [(ghost: Ghost(), imageView: UIImageView(image: UIImage(named: "Ghost")))]
                
                tapRecognizer.addTarget(self, action: "tappedGhost:")
                temp[0].imageView.addGestureRecognizer(tapRecognizer)
                temp[0].imageView.userInteractionEnabled = true
                
                var xy = CGFloat(index*15)
                var dimensions = CGFloat(50)
                
                temp[0].imageView.frame = CGRectMake(xy, xy, dimensions, dimensions)
                
                self.view.addSubview(temp[0].imageView)
                
                ghostArray! += temp
                println("\(ghostArray!.count)")
                /*
                tapRecognizer.addTarget(self, action: "tappedGhost")
                ***ghost.addGestureRecognizer(tapRecognizer)
                ghost.userInteractionEnabled = true
                */
            }
        }
    }
    func tappedGhost(recognizer: UIGestureRecognizer) {
        
        recognizer.view!.hidden = true
        println("no of ghosts left: \(ghostArray!.count)")
        println("hide this ghost")
        
        for index in 0...ghostArray!.count {
            if ghostArray![index].imageView.hidden == true {
                ghostArray!.removeAtIndex(index)
            }
        }
        if ghostArray!.count == 0 {
            alarm.currentState = .Play
            let alertController = UIAlertController(title: "Congratulations!", message: "You defeated all the ghosts", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func alarmToggle(sender: AnyObject) {
        
        //alarmTime.hidden = !alarmTime.hidden
        //alarmToggle.selected = !alarmToggle.selected
        if(!alarm.isSet) {
            alarmTime.hidden = false
            alarmToggle.selected = false
            if let time = alarm.time  {
                NotificationHelper.handleScheduling(alarm.time!, numOfNotifications: 3, delayInSeconds: 0)
                alarm.isSet = true
                alarmTime.text = alarm.dateFormatter.stringFromDate(alarm.time!)
            }
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
