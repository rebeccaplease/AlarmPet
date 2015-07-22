//
//  Ghost.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/17/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit

class Ghost {
    /*
    var currentLocation: CGRect
    func move() -> CGRect {
        
        return
    }
*/
    var ghostArray:[(ghost: Ghost, imageView: UIImageView)]? = nil
    
    class var sharedInstance : Ghost {
        struct Static {
            static let instance : Ghost = Ghost()
        }
        return Static.instance
    }
    
    
    
}