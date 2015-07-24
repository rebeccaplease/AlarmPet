//
//  StateMachine.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/24/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import RealmSwift

class StateMachine {
    
    enum State: String, Printable {
        case Defend = "Defend" //alarm going off
        case Play = "Play"
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    static var currentState: State = .Play
    
    static func checkState() {
        
        //if current time is within 30 minutes of alarm time
        
        if let alarm = getRealmAlarm() {
            //returns time difference in seconds (negative if time is earlier than current time)
            var interval = alarm.time.timeIntervalSinceNow
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
    
    static func getRealmAlarm() -> Alarm? {
        let realm = Realm()
        let alarm = realm.objects(Alarm)
        if alarm.count > 0 {
            return alarm.first
        }
        else {
            return nil
        }
    }
    
    static func saveRealmAlarm(alarm: Alarm) {
        let realm = Realm()
        realm.write {
            realm.add(alarm)
        }
    }
    static func deleteRealmAlarm() {
        let realm = Realm()
        realm.write {
            realm.deleteAll()
        }
    }
}