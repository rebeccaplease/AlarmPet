//
//  Pet.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/16/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit
//import RealmSwift

class Pet {
    class var sharedInstance : Pet {
        struct Static {
            static let instance : Pet = Pet()
        }
        return Static.instance
    }
    var health: Int = 100
    var affection: Int = 0
    var position: CGRect = CGRect(x: 250, y: 250, width: 100, height: 100)
    
}