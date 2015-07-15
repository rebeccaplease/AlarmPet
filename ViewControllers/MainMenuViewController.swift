//
//  MainMenuViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/13/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new View Controller using segue.destinationViewController.
        // Pass the selected object to the new View Controller.
        
        /*if (segue.identifier == "Alarm") {
        
            let alarmViewController = segue.destinationViewController as! AlarmViewController
            
        } */
    }
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        println("unwinding")
    }

}
