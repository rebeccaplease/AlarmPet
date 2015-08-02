//
//  Alarm.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/16/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import RealmSwift

class Alarm: Object {
    
    dynamic var time: NSDate = NSDate()
    dynamic var isSet: Bool = false
    
    dynamic var dailyWin: NSDate = NSDate()
}