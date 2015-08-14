//
//  AboutViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 8/4/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.userInteractionEnabled = false
        textView.textColor = UIColorFromHex(0x140C60, alpha: 1.0)
        textView.text = "Make School \nIcon credits: https://icons8.com/license/ \nSounds made in GarageBand\nSpecial thanks to: \n Adam Reis \n Olivia Ross \n Febria Roosita \n Thuc Tran, and \nDeer"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
