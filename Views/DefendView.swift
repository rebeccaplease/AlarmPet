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
    static let tapRecognizer = UITapGestureRecognizer()
    
    static func createGhosts(vc: UIViewController, ghostArray array:[(ghost: Ghost, imageView: UIImageView)]?) -> [(ghost: Ghost, imageView: UIImageView)]?  {
        if var array = array {
            return array
        }
        else {
            var tempArray: [(ghost: Ghost, imageView: UIImageView)] = []
            
            for index in 1...10 {
                
                var temp = [(ghost: Ghost(), imageView: UIImageView(image: UIImage(named: "Ghost")))]
                
                tapRecognizer.addTarget(self, action: "tappedGhost:")
                temp[0].imageView.addGestureRecognizer(tapRecognizer)
                temp[0].imageView.userInteractionEnabled = true
                
                var xy = CGFloat(index*15)
                var dimensions = CGFloat(50)
                
                temp[0].imageView.frame = CGRectMake(xy, xy, dimensions, dimensions)
                
                vc.view.addSubview(temp[0].imageView)
                
                tempArray += temp
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
}