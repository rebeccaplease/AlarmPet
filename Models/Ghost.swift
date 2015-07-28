//
//  Ghost.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/17/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit

class Ghost: NSObject {

    static var size: Int = 50
    //static var delay: NSTimeInterval = 10
    static var currentIndex: Int = 0
    static var ghostArrayCount = 10
    
    static var ghostArray:[(ghost: Ghost, imageView: UIImageView, tap: UITapGestureRecognizer)]? = nil
    
    //MARK: Class methods
    
    static func updateGhostArray(array: [(ghost: Ghost, imageView: UIImageView, tap: UITapGestureRecognizer)]?) {
        ghostArray = array
    }
    
    static func createGhosts(vc: UIViewController)  {
        //let ghost = Ghost.sharedInstance
        //if user exits out without defeating all the ghosts
        //var ghostArray = ghost.ghostArray
        
        if var ghostArray = ghostArray {
            return
        }
            //create and draw ghosts on screen
        else {
            ghostArray = []
            
            for index in 0...ghostArrayCount-1{
                
                var temp = [(ghost: Ghost(), imageView: UIImageView(image: UIImage(named: "Ghost")), tap: UITapGestureRecognizer() )]
                
                temp[0].tap.addTarget(self, action: "tappedGhost:")
                temp[0].imageView.addGestureRecognizer(temp[0].tap)
                temp[0].imageView.userInteractionEnabled = false
                temp[0].imageView.hidden = true
                
                var xy = CGFloat(index*24)
                var dimensions = CGFloat(50)
                
                temp[0].imageView.frame = CGRectMake(xy, xy, dimensions, dimensions)
                
                ghostArray! += temp
                vc.view.addSubview(ghostArray![index].imageView)
                println("\(ghostArray!.count)")
                var delay = NSTimeInterval(index*5)
                
                NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "move:", userInfo: nil, repeats: false)
                
            }
        }
    }
    
    //loop through and move a ghost
    static func move(timer: NSTimer) {
        var position = CGRect(x: 200, y: 200, width: size, height: size)
        
        UIView.animateWithDuration(2.0, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            //show ghost and move it
            self.ghostArray![self.currentIndex].imageView.hidden = false
            self.ghostArray![self.currentIndex].imageView.userInteractionEnabled = true
            self.ghostArray![self.currentIndex].imageView.frame = position
            }, completion: nil)
        
        self.currentIndex++
    }
    
    static func tappedGhost(recognizer: UITapGestureRecognizer) {
        
        //hide ghost view
        recognizer.view?.hidden = true
        //user can no longer tap on ghost
        recognizer.view?.userInteractionEnabled = false
        ghostArrayCount--
        
        println("no of ghosts left: \(ghostArrayCount)")
        
        if ghostArrayCount == 0 {
            StateMachine.currentState = .Play
            
            ghostArray = nil
            currentIndex = 0
            ghostArrayCount = 10
            
            println("You win!")
        }
    }
    
}