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
    
    dynamic var x: Float  = 250
    dynamic var y: Float = 250
    
    dynamic var width: Int = 100
    dynamic var height = 100
}