//
//  PetView.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/23/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class MainView: UIView {
    
    @IBOutlet weak var setAlarm: UIButton!
    
    @IBOutlet weak var alarmTime: UILabel!
    
    @IBOutlet weak var toggleAlarm: UIButton!
    
    
    //
    
    func updateColor(hour: Int) {
       /*
        let colorTop = UIColor(red: 192.0/255.0, green: 38.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 35.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        
        let gl: CAGradientLayer
        
            gl = CAGradientLayer()
            gl.colors = [ colorTop, colorBottom]
            gl.locations = [ 0.0, 1.0]
        */
        
        if hour == 5 {
            //5 - 6 am
            self.backgroundColor = UIColorFromHex(0x2A71DF, alpha: 1.0)
        }
            //6 - 7 am
        else if hour == 6 {
            self.backgroundColor = UIColorFromHex(0xFBA600, alpha: 1.0)
        }
            //7 - 8 am
        else if hour == 7 {
            self.backgroundColor = UIColorFromHex(0xDFA012, alpha: 1.0)
        }
            //9 - 10 am
        else if hour == 8 {
            self.backgroundColor = UIColorFromHex(0xFBA600, alpha: 1.0)
        }
        else {
            //11am - 12pm
            self.backgroundColor = UIColorFromHex(0x1CE1DF, alpha: 1.0)
        }
        
    }
    
}
