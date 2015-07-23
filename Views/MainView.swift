//
//  PetView.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/23/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class MainView: UIView {

    @IBOutlet weak var pet: UIImageView!
    
    @IBOutlet weak var setAlarm: UIButton!
    
    @IBOutlet weak var alarmTime: UILabel!
    
    @IBOutlet weak var toggleAlarm: UIButton!
    
    //var ghostArray:[(ghost: Ghost, imageView: UIImageView, tap: UITapGestureRecognizer)]? = nil
    
    @IBAction func toggleAlarm(sender: AnyObject) {
    }
    
    func hideMenu() {
        setAlarm.hidden = true
        alarmTime.hidden = true
        toggleAlarm.hidden = true
    }
    
    
}
