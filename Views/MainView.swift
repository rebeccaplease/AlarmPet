//
//  PetView.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/23/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class MainView: UIView {
    

    @IBOutlet weak var petImageView: UIImageView!
    
    @IBOutlet weak var setAlarm: UIButton!
    
    @IBOutlet weak var alarmTime: UILabel!
    
    @IBOutlet weak var toggleAlarm: UIButton!
    
    @IBOutlet weak var winLabel: UILabel!
    
    
    func hideMenu() {
        setAlarm.hidden = true
        alarmTime.hidden = true
        toggleAlarm.hidden = true
    }

    //var alarm: Alarm? = nil
    
    
    
}
