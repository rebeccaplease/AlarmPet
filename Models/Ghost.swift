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
    
    var imageView: UIImageView
    var timer: NSTimer
    
    var animationImages: [UIImage] = []
    
    var weakness: String = ""
    
    init(id: Int, timer: NSTimer, weakness: String) {
        self.id = id
        self.dead = false
        
        var name: String = "Ghost-\(weakness)"
    
        self.imageView = UIImageView(image: UIImage(named: name))
        
        self.weakness = weakness
        
        //for index in 0...10 {
            
          //  animationImages.append(UIImage(named: "\(name)-\(index)")!)
       // }
        
        //self.imageView.animationImages = animationImages
        self.imageView.animationDuration = 0.5
        
        self.timer = timer
        
    }
}