//
//  StateMachine.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/24/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class StateMachine {
    //MARK: State
    enum State: String, Printable {
        case Defend = "Defend" //alarm going off
        case Play = "Play"
        case Win = "Win"
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    static var currentState: State = .Play
    
    static func checkState() {
        
        if let alarm = getRealmAlarm() {
            //returns time difference in seconds (negative if time is earlier than current time)
            if alarm.isSet == true {
                var interval = alarm.time.timeIntervalSinceNow
                println("\(interval)")
                //if current time is within 30 minutes of alarm time
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
        }
        
        println(currentState)
    }
    
    /*static func displayWinAlert(vc: UIViewController) {
        
        let alertController = UIAlertController(title: "Congratulations!", message: "You defeated all the ghosts", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Yay!", style: UIAlertActionStyle.Default, handler: { action in
            self.currentState = .Play
            return
        }))
        
        vc.presentViewController(alertController, animated: true, completion: nil)
        
    }*/
    
    //MARK: Realm Alarm
    
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
    
    static func updateRealmAlarm(alarm: Alarm, time: NSDate, isSet: Bool) {
        let realm = Realm()
        realm.write{
            if(alarm.time != time) {
                alarm.time = time
            }
            if(alarm.isSet != isSet) {
                alarm.isSet = isSet
            }
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
    
    //MARK: Realm Pet
    static func getRealmPet() -> Pet?{
        let realm = Realm()
        let pet = realm.objects(Pet)
        if pet.count > 0 {
            return pet.first
        }
        else {
            return nil
        }
    }
    
    
}