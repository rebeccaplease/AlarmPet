//
//  Ghost.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 8/3/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit

class Ghost {
    
    var id: Int
    var dead: Bool
    //var stoppedMoving: Bool
    var imageView: UIImageView
    var timer: NSTimer
    var animation = ["Ghost.png"]
    var animationImages: [UIImage] = []
    
    init(id: Int, imageView: UIImageView, timer: NSTimer) {
        self.id = id
        self.dead = false
        
        self.imageView = imageView
        
        for element in animation {
            animationImages.append(UIImage(named: element)!)
        }
        
        self.imageView.animationImages = animationImages
        self.imageView.animationDuration = 0.5
        
        self.timer = timer
        
    }
}