//
//  PetViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/14/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class PetViewController: UIViewController {
    
    
    
    @IBOutlet weak var alarmTime: UILabel!
    
    @IBOutlet weak var alarmToggle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func alarmToggle(sender: AnyObject) {
        
        //alarmTime.hidden = !alarmTime.hidden
        //alarmToggle.selected = !alarmToggle.selected
        if(!Alarm.sharedInstance.isSet) {
            alarmTime.hidden = false
            alarmToggle.selected = false
        
            NotificationHelper.handleScheduling(Alarm.sharedInstance.time, numOfNotifications: 3, delayInSeconds: 0)
            Alarm.sharedInstance.isSet = true
            alarmTime.text = Alarm.sharedInstance.dateFormatter.stringFromDate(Alarm.sharedInstance.time)
        }
        else {
            alarmTime.hidden = true
            alarmToggle.selected = true
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            Alarm.sharedInstance.isSet = false
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
