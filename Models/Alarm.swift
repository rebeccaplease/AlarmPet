//
//  Alarm.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/16/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation

class Alarm {
    //Singleton
    static let sharedInstance = Alarm()
    var time: NSDate = NSDate()
    
    var isSet: Bool = true
    
    enum State {
        case Defend //alarm going off
        case Play
    }
    
    var currentState = State.Play
    

    var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return formatter
        }()
   
}