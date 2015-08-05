//
//  GhostViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/17/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit


class GhostViewController: UIViewController{
    
    @IBOutlet weak var healthBar: UIProgressView!
    @IBOutlet weak var petImageView: UIImageView!
    
    var pet: Pet?
    
    var size: CGFloat = 50
    //static var delay: NSTimeInterval = 10
    var currentIndex: Int = 0
    var ghostArrayCount = 10
    var attackIndex = 0
    var petVC: PetViewController?
    
    var ghostArray:[ Ghost ]? = nil
    
    var stationary: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthBar.progress = 1.0
        
        let swipe = UISwipeGestureRecognizer()
        swipe.addTarget(self, action: "healPet:")
        petImageView.addGestureRecognizer(swipe)
        
        pet = RealmHelper.getRealmPet()
    }
    
    func getGhostCount() -> Int{
        return ghostArrayCount
    }
    
    func updateGhostArray(array: [ Ghost ]?) {
        ghostArray = array
    }
    
    func healPet(recognizer: UISwipeGestureRecognizer) {
        healthBar.progress += 0.05
    }
    
    func createGhosts(){
        
        if var ghostArray = ghostArray {
            return
        }
            //create and draw ghosts on screen
        else {
            
            //let mainView = vc.view as! MainView
            let tap = self.view.gestureRecognizers![0] as! UITapGestureRecognizer
            tap.addTarget(self, action: "tappedGhost:")
            self.view.addGestureRecognizer(tap)
            
            ghostArray = []
            //firstAppearance = true
            
            //for index in 0...ghostCount-1{
            for index in 0...ghostArrayCount-1 {
                
                var delay = NSTimeInterval(index)
                
                // var temp = [(ghost: Ghost(id: index), imageView: UIImageView(image: UIImage(named: "Ghost")), timer: NSTimer(timeInterval: delay, target: self, selector: "move:", userInfo: nil, repeats: false) )]
                
                //NSRunLoop.currentRunLoop().addTimer(temp[0].timer, forMode: NSDefaultRunLoopMode)
                
                var temp = Ghost(id: index,
                                imageView: UIImageView(image: UIImage(named: "Ghost")),
                                timer: NSTimer(timeInterval: 5, target: self, selector: "attack:", userInfo: nil, repeats: true))
                                    
                //var xy = CGFloat(index*10)
                var x = self.view.center.x - size - 100
                var y = self.view.center.y - size - 100
                
                //if ghosts do not move
                if stationary {
                   temp.imageView.userInteractionEnabled = true
                    temp.imageView.hidden = false
                    
                    x += CGFloat(index * 4)
                }
                    
                else {
                    NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "move:", userInfo: nil, repeats: false)
                    
                    temp.imageView.userInteractionEnabled = false
                    temp.imageView.hidden = true
                }
                
                
                
                var dimensions = CGFloat(50)
                
                temp.imageView.frame = CGRectMake(x, x, dimensions, dimensions)
                
                ghostArray!.append(temp)
                
                //**
                self.view.addSubview(ghostArray![index].imageView)
                
                
                println("\(ghostArray!.count)")
                
                if index > ghostArrayCount/2 {
                    stationary = true
                }
            }
        }
    }
    
    
    //loop through and move a ghost
    func move(timer: NSTimer) {
        
        /*var sizeRect = UIScreen.mainScreen().applicationFrame
        var x = sizeRect.size.width/2
        var y = sizeRect.size.height/2*/
        
        var x = self.view.center.x - size
        var y = self.view.center.y - size
        
        var random: Int = Int(arc4random_uniform(2))
        if( random < 1) {
            x -= 50
        }
        else {
            x += 50
        }
        random = Int(arc4random_uniform(2))
        if( random < 1) {
            y -= 50
        }
        else {
            y += 50
        }
        
        var position = CGRect(origin: CGPoint(x: CGFloat(x), y: CGFloat(y)), size: CGSize(width: size, height: size))
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            //show ghost and move it
            
            self.ghostArray![self.currentIndex].imageView.hidden = false
            self.ghostArray![self.currentIndex].imageView.userInteractionEnabled = false
            self.ghostArray![self.currentIndex].imageView.frame = position
            
            },
            completion: { action in
                //attack pet
                //                for (index, element) in enumerate(self.ghostArray!) {
                //                    if element.imageView.hidden == false && element.ghost.stoppedMoving {
                //                        NSRunLoop.currentRunLoop().addTimer(element.timer, forMode: NSDefaultRunLoopMode)
                //                    }
                //                }
                // if( self.ghostArray![self.currentIndex].imageView.hidden == false){
                //if timer is still valid
                
                //   NSRunLoop.currentRunLoop().addTimer(self.ghostArray![self.currentIndex].timer, forMode: NSDefaultRunLoopMode)
                //  }
                if( self.ghostArray![self.attackIndex].imageView.hidden == false) {
                    
                    NSRunLoop.currentRunLoop().addTimer(self.ghostArray![self.attackIndex].timer, forMode: NSDefaultRunLoopMode)
                    println("attack index: \(self.attackIndex)")
                    println("time: \(self.dateFormatter.stringFromDate(NSDate()))")
                    
                }
                self.attackIndex++
        })
        self.currentIndex++
    }
    
    func attack(timer: NSTimer) {
        //var pet = RealmHelper.getRealmPet()!
        
        // RealmHelper.updateRealmPet(pet!.health-5)
        
        // pet!.health -= 5
        
        self.healthBar.setProgress(self.healthBar.progress-0.01, animated: false)
        if healthBar.progress <= 0 {
            displayDeadAlert()
        }
        
        println("attack!: \(dateFormatter.stringFromDate(NSDate()))")
    }
    
    var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        return formatter
        }()
    
    func detectTap(gesture: UITapGestureRecognizer) -> Int{
        
        if let ghostArray = ghostArray {
            for (index, ghost) in enumerate(ghostArray) {
                var tapLocation = gesture.locationInView(ghost.imageView.superview)
                if ghost.imageView.hidden == false {
                    if ghost.imageView.layer.presentationLayer().frame.contains(tapLocation) {
                        if(!ghost.dead) {
                            println("id: \(ghost.id)")
                            ghost.dead = true
                            return ghost.id
                        }
                    }
                }
            }
        }
        return -1
    }
    
    func tappedGhost(recognizer: UITapGestureRecognizer) {
        
        // if(RealmHelper.getRealmState()!.state == "Defend") {
        var ghostID = detectTap(recognizer)
        
        if ghostID >= 0 {
            
            ghostArray![ghostID].imageView.hidden = true
            //user can no longer tap on ghost
            
            ghostArray![ghostID].imageView.userInteractionEnabled = false
            
            ghostArray![ghostID].timer.invalidate()
            
            ghostArrayCount--
            
            println("no of ghosts left: \(ghostArrayCount)")
            
            if ghostArrayCount == 0 {
                //RealmHelper.currentState = .Play
                RealmHelper.updateRealmState("Win")
                
                displayWinAlert()
                
                ghostArray = nil
                currentIndex = 0
                ghostArrayCount = 10
                attackIndex = 0
                stationary = false
                
                RealmHelper.updateRealmAlarmDidWin(true)
                
                RealmHelper.updateRealmPet(affection: 5)
                
                petVC!.affectionLabel.setTitle("\(pet!.affection + 5)", forState: UIControlState.Normal)
                
                
                println("You win!")
                
            }
        }
    }
    
    func displayWinAlert() {
        
        let alertController = UIAlertController(title: "Congratulations!",
            message: "You defeated all the ghosts",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Yay!",
            style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func displayDeadAlert() {
        let alertController = UIAlertController(title: "Your pet died!",
            message: "Oh no :(",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "Revive Pet",
            style: UIAlertActionStyle.Default,
            handler: nil))
        
        
        /*alertController.addAction(UIAlertAction(title: "Go to Funeral",
        style: UIAlertActionStyle.Default,
        handler: nil)) */
        
        self.presentViewController(alertController, animated: true, completion: {action in
            self.cancelTimers()
        })
    }
    
    func cancelTimers() {
        for (index, element) in enumerate(ghostArray!) {
            element.timer.invalidate()
        }
        
    }
    
    func updatePetHealth() {
        //update pet health depending on the current time and alarm time
        let alarm = RealmHelper.getRealmAlarm()
        let pet = RealmHelper.getRealmPet()
        
        //difference in seconds between alarm time and when app is opened
        var difference = alarm!.time.timeIntervalSinceNow
        var health = Float((1000 + difference)/1000.0)
        println("health: \(health)")
        healthBar.progress = health
        
        if healthBar.progress <= 0 {
            displayDeadAlert()
        }
        
        RealmHelper.updateRealmPet(Int(health*100))
        
    }
    
    
}

