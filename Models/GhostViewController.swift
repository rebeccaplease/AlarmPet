//
//  GhostViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/17/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit

protocol GhostDelegate {
    func displayWinAlert()
}

class GhostViewController: UIViewController{
    
    
    var size: CGFloat = 50
    //static var delay: NSTimeInterval = 10
    var currentIndex: Int = 0
    var ghostArrayCount = 10
    
    var delegate: GhostDelegate?
    
    var ghostArray:[ (ghost: Ghost, imageView: UIImageView, timer: NSTimer) ]? = nil
    
    
    func getGhostCount() -> Int{
        return ghostArrayCount
    }
    
    func updateGhostArray(array: [ (ghost: Ghost, imageView: UIImageView, timer: NSTimer) ]?) {
        ghostArray = array
    }
    
    //static func createGhosts(vc: UIViewController) {
    func createGhosts(){
        //if user exits out without defeating all the ghosts
        //var ghostArray = ghost.ghostArray
        
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
                
                
                //NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "move:", userInfo: nil, repeats: false)
                
            }
        }
    }
    
    
    //loop through and move a ghost
     func move(timer: NSTimer) {
        
        /*var xandy = StateMachine.getPetPosition()
        
        var x = xandy.0 - 10
        var random: Int = Int(arc4random_uniform(2))
        if( random < 1) {
        x -= 150
        }
        let y = xandy.1 + 60 + Float(currentIndex * 20)
        */
        
        //var position = CGRect(x: CGFloat(x), y: CGFloat(y), width: size, height: size)
        //var position = CGPoint(x: CGFloat(x), y: CGFloat(y))
        
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
            //hide ghost view
            //recognizer.view?.hidden = true
            ghostArray![ghostID].imageView.hidden = true
            //user can no longer tap on ghost
            //recognizer.view?.userInteractionEnabled = false
            ghostArray![ghostID].imageView.userInteractionEnabled = false
            //ghostArray![ghostID].imageView.layer.presentationLayer() = false
            
            ghostArrayCount--
            
            println("no of ghosts left: \(ghostArrayCount)")
            
            if ghostArrayCount == 0 {
                //StateMachine.currentState = .Play
                StateMachine.updateRealmState("Win")
                // StateMachine.updateRealmStateAndGhosts(gameState: "Play", numGhosts: 0)
                
                //let mainView = ghostArray![ghostID].imageView.superview as! MainView
                //mainView.winLabel.hidden = false
                
                ghostArray = nil
                currentIndex = 0
                ghostArrayCount = 10
                
                StateMachine.updateRealmAlarmDidWin(true)
                
                println("You win!")
                
            }
        }
    }
    // }
    
    /*  static func invalidateTimers() {
    
    for (index, ghost) in enumerate(ghostArray!) {
    ghost.timer.invalidate()
    }
    }
    */
}

