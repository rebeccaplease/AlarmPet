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
    dynamic var didWin: Bool = false
    
    //save last daily win date
   // dynamic var dailyWinDate: NSDate? = nil
    //if dailyWin is false, don't change the dailyWinDate
    //dynamic var dailyWin: Bool = false
}