//
//  Alarm.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/16/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
//import RealmSwift

class Alarm {
    //Singleton
    //static let sharedInstance = Alarm()
    class var sharedInstance : Alarm {
        struct Static {
            static let instance : Alarm = Alarm()
        }
        return Static.instance
    }
    
    var time: NSDate? = nil
    
    var isSet: Bool = true
    
    enum State: String, Printable {
        case Defend = "Defend" //alarm going off
        case Play = "Play"
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    var currentState = State.Play
    
    var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        return formatter
        }()
    
    func checkState() {
        //if current time is within 30 minutes of alarm time
        if let time = time {
            //returns time difference in seconds (negative if time is earlier than current time)
            var interval = time.timeIntervalSinceNow
            println("\(interval)")
            if (interval < 0 && interval > -30*60) {
                currentState = .Defend
            }
            else {
                currentState = .Play
            }
        }
        else {
            currentState = .Play
        }
        
        println(currentState)
    }
}