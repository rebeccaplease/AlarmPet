//
//  Pet.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/16/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Pet: Object {
    dynamic var health: Int = 100
    dynamic var affection: Int = 0
    //dynamic var position: CGRect = CGRect(x: 250, y: 250, width: 100, height: 100)
    
    dynamic var x: Int = 250
    dynamic var y: Int = 250
    
    dynamic var width: Int = 100
    dynamic var height = 100
}