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

        // Do any additional setup after loading the view.
        //textView.textColor = UIColor(red:0.36, green:0.77, blue:0.49, alpha:1.0)
        
        textView.textColor = UIColorFromHex(0x140C60, alpha: 1.0)
        textView.text = "Make School \nIcon credits: https://icons8.com/license/ \nSounds made in GarageBand\nSpecial thanks to: \n Adam Reis \n Olivia Ross \n Febria Roosita\n Eric Kim \n Thuc Tran, and \nDeer"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
