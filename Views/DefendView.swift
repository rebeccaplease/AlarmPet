//
//  DefendView.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/22/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit

class DefendView: NSObject {
    
    //array of possible gestures
    //static let tapRecognizer = UITapGestureRecognizer()

    
    static func createGhosts(vc: UIViewController) -> [(ghost: Ghost, imageView: UIImageView, tap: UITapGestureRecognizer)]?  {
        let ghost = Ghost.sharedInstance
        //if user exits out without defeating all the ghosts
        var ghostArray = ghost.ghostArray
        
        if var ghostArray = ghostArray {
            return ghostArray
        }
            //create and draw ghosts on screen
        else {
            var tempArray: [(ghost: Ghost, imageView: UIImageView, tap: UITapGestureRecognizer)] = []
            
            for index in 0...9{
                
                var temp = [(ghost: Ghost(), imageView: UIImageView(image: UIImage(named: "Ghost")), tap: UITapGestureRecognizer() )]
                
                temp[0].tap.addTarget(self, action: "tappedGhost:")
                temp[0].imageView.addGestureRecognizer(temp[0].tap)
                temp[0].imageView.userInteractionEnabled = true
                
                var xy = CGFloat(index*24)
                var dimensions = CGFloat(50)
                
                temp[0].imageView.frame = CGRectMake(xy, xy, dimensions, dimensions)
                
                tempArray += temp
                vc.view.addSubview(tempArray[index].imageView)
                println("\(tempArray.count)")
               
                /*
                tapRecognizer.addTarget(self, action: "tappedGhost")
                ***ghost.addGestureRecognizer(tapRecognizer)
                ghost.userInteractionEnabled = true
                */
                
            }
            return tempArray
        }
    }
    
    static func tappedGhost(recognizer: UITapGestureRecognizer) {
        
        let alarm = Alarm.sharedInstance
        let ghost = Ghost.sharedInstance
        //var ghostArray = ghost.ghostArray
        
        recognizer.view?.hidden = true
        println("no of ghosts left: \(ghost.ghostArray!.count)")
        println("hide this ghost")
        
        for (index, element) in enumerate(ghost.ghostArray!) {
            if element.imageView.hidden == true {
                ghost.ghostArray!.removeAtIndex(index)
                //break
            }
        }
        if ghost.ghostArray!.count == 0 {
            alarm.currentState = .Play
            /*let alertController = UIAlertController(title: "Congratulations!", message: "You defeated all the ghosts", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.Default,handler: nil))
            
            vc.presentViewController(alertController, animated: true, completion: nil)
            */
            //alarm.time = nil
            
            println("You win!")
        }

        //println("Tapped with recognizer!")
    }
   /* static func tappedGhost() {
        println("Tapped without recognizer!")
    }
 */
}