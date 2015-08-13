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
        
        textView.text = "Make School \nIcon credits: https://icons8.com/license/ \nSounds made in GarageBand\nSpecial thanks to: \n Adam Reis \n Olivia Ross \n Febria \n Eric Kim \n Thuc Tran, and \nDeer"
        
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
