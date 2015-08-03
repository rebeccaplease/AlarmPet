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
    
    var size: CGFloat = 50
    //static var delay: NSTimeInterval = 10
    var currentIndex: Int = 0
    var ghostArrayCount = 10
    
    var ghostArray:[ (ghost: Ghost, imageView: UIImageView, timer: NSTimer) ]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthBar.progress = 1.0
    }
    
    func getGhostCount() -> Int{
        return ghostArrayCount
    }
    
    func updateGhostArray(array: [ (ghost: Ghost, imageView: UIImageView, timer: NSTimer) ]?) {
        ghostArray = array
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
            
            //for index in 0...ghostCount-1{
            for index in 0...ghostArrayCount-1 {
                
                var delay = NSTimeInterval(index)
                
                var temp = [(ghost: Ghost(id: index), imageView: UIImageView(image: UIImage(named: "Ghost")), timer: NSTimer(timeInterval: delay, target: self, selector: "move:", userInfo: nil, repeats: false) )]
                
                NSRunLoop.currentRunLoop().addTimer(temp[0].timer, forMode: NSDefaultRunLoopMode)
                
                temp[0].imageView.userInteractionEnabled = false
                temp[0].imageView.hidden = true
                
                var xy = CGFloat(index*10)
                
                var dimensions = CGFloat(50)
                
                temp[0].imageView.frame = CGRectMake(xy, xy, dimensions, dimensions)
                
                ghostArray! += temp
                
                //**
                self.view.addSubview(ghostArray![index].imageView)
                
                
                println("\(ghostArray!.count)")
                
            }
        }
    }
    
    
    //loop through and move a ghost
     func move(timer: NSTimer) {
        
        var sizeRect = UIScreen.mainScreen().applicationFrame
        var x = sizeRect.size.width/2
        var y = sizeRect.size.height/2
        
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
            
            }, completion: nil)
        
        self.currentIndex++
    }
    
    
    func detectTap(gesture: UITapGestureRecognizer) -> Int{
        
        if let ghostArray = ghostArray {
            for (index, ghost) in enumerate(ghostArray) {
                var tapLocation = gesture.locationInView(ghost.imageView.superview)
                if ghost.imageView.hidden == false {
                    if ghost.imageView.layer.presentationLayer().frame.contains(tapLocation) {
                        if(!ghost.ghost.dead) {
                            println("id: \(ghost.ghost.id)")
                            ghost.ghost.dead = true
                            return ghost.ghost.id
                        }
                    }
                }
            }
        }
        return -1
    }
    
    func tappedGhost(recognizer: UITapGestureRecognizer) {
        
        // if(StateMachine.getRealmState()!.state == "Defend") {
        var ghostID = detectTap(recognizer)
        
        if ghostID >= 0 {
           
            ghostArray![ghostID].imageView.hidden = true
            //user can no longer tap on ghost
        
            ghostArray![ghostID].imageView.userInteractionEnabled = false
            
            ghostArrayCount--
            
            println("no of ghosts left: \(ghostArrayCount)")
            
            if ghostArrayCount == 0 {
                //StateMachine.currentState = .Play
                StateMachine.updateRealmState("Win")
           
                displayWinAlert()
                
                ghostArray = nil
                currentIndex = 0
                ghostArrayCount = 10
                
                StateMachine.updateRealmAlarmDidWin(true)
                
                println("You win!")
                
            }
        }
    }
    
    func displayWinAlert() {
        
        let alertController = UIAlertController(title: "Congratulations!", message: "You defeated all the ghosts", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func updatePetHealth() {
        //update pet health depending on the current time and alarm time
        let alarm = StateMachine.getRealmAlarm()
        let pet = StateMachine.getRealmPet()
        
        //difference in seconds between alarm time and when app is opened
        var difference = alarm!.time.timeIntervalSinceNow
        var health = Float((1000 + difference)/1000.0)
        println("health: \(health)")
        healthBar.progress = health
        
        StateMachine.updateRealmPet(Int(health*100))
        
    }
}

