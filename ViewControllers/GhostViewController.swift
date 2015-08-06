//
//  GhostViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/17/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit


class GhostViewController: UIViewController{
    
    @IBOutlet weak var healthBar: UIProgressView!
    @IBOutlet weak var petImageView: UIImageView!
    
    var pet: Pet?
    
    var size: CGFloat = 50
    
    var currentIndex: Int = 0
    var ghostArrayCount = 10
    var attackIndex = 0
    
    
    var ghostArray:[ Ghost ]? = nil
    
    var stationary: Bool = false
    
    var brightness: Double = 0
    
    
    @IBOutlet weak var affectionLabel: UIButton!
    
    
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
    
    var currentState: State = .Play {
        
        didSet {
            switch(currentState) {
            case .Win:
                //displayWinAlert()
                currentState  = .Play
            case .Defend:
                
                NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "increaseBrightness:", userInfo: nil, repeats: true)
                UIScreen.mainScreen().brightness = 0
                petImageView.userInteractionEnabled = true
            default:
                println("default")
                petImageView.userInteractionEnabled = true
            }
        }
        
    }
    
    func increaseBrightness(timer: NSTimer) {
        brightness += 0.0025
        UIScreen.mainScreen().brightness = CGFloat(brightness)
        if brightness >= 1.0 {
            timer.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthBar.progress = 1.0
        
        /*let swipe = UISwipeGestureRecognizer()
        swipe.addTarget(self, action: "healPet:")
        swipe.direction = .Left | .Right | .Up | .Down
        petImageView.addGestureRecognizer(swipe)
        */
        
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: "healPet:")
        petImageView.addGestureRecognizer(pan)
    }
    
    func healPet(recognizer: UIPanGestureRecognizer) {
        var velocity = recognizer.velocityInView(self.view)
        if velocity.x > 0 || velocity.y > 0 {
            healthBar.progress += 0.0001
            println("healing")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        pet = RealmHelper.getRealmPet()
        affectionLabel.setTitle("\(pet!.affection)", forState: UIControlState.Normal)
    }
    
    func getGhostCount() -> Int{
        return ghostArrayCount
    }
    
    func updateGhostArray(array: [ Ghost ]?) {
        ghostArray = array
    }
    
    //draw ghosts
    func createGhosts(){
        
        //if there are already ghosts in the ghostArray
        if var ghostArray = ghostArray {
            return
        }
            //create and draw ghosts on screen
        else {
            
            let tap = self.view.gestureRecognizers![0] as! UITapGestureRecognizer
            tap.addTarget(self, action: "tappedGhost:")
            self.view.addGestureRecognizer(tap)
            
            ghostArray = []
            
            for index in 0...ghostArrayCount-1 {
                
                var delay = NSTimeInterval(index)
                
                //NSRunLoop.currentRunLoop().addTimer(temp[0].timer, forMode: NSDefaultRunLoopMode)
                
                var temp = Ghost(id: index,
                    imageView: UIImageView(image: UIImage(named: "Ghost")),
                    timer: NSTimer(timeInterval: 5, target: self, selector: "attack:", userInfo: nil, repeats: true))
                
                //var xy = CGFloat(index*10)
                var x: CGFloat = 0
                var y: CGFloat = 0
                
                
                
                if !stationary {
                    var random: Int = Int(arc4random_uniform(3))
                    if( random == 1) {
                        x = 0
                    }
                    else if random == 2{
                        x = self.view.bounds.height
                    }
                    else {
                        x = self.view.bounds.height/2
                    }
                    random = Int(arc4random_uniform(3))
                    if( random == 1) {
                        y = 0
                    }
                    else if random == 2{
                        y = self.view.bounds.width
                    }
                    else {
                        y = self.view.bounds.width/2
                    }
                }
                
                //if ghosts do not move
                if stationary {
                    temp.imageView.userInteractionEnabled = true
                    temp.imageView.hidden = false
                    
                    x = self.view.center.x - size/2
                    y = self.view.center.y - size
                    var offset = CGFloat(75)
                    
                    var random: Int = Int(arc4random_uniform(4))
                    if( random == 1) {
                        x -= offset
                    }
                    else if (random == 2){
                        x += offset
                    }
                        
                    else if( random == 3) {
                        y -= offset
                    }
                    else {
                        y += offset
                    }
                    
                }
                    
                else {
                    NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "move:", userInfo: nil, repeats: false)
                    
                    temp.imageView.userInteractionEnabled = false
                    temp.imageView.hidden = true
                }
                
                
                //temp.imageView.frame = CGRectMake(x, y, dimensions, dimensions)
                
                temp.imageView.frame = CGRect(x: x, y: y, width: size, height: size)
                
                ghostArray!.append(temp)
                
                self.view.addSubview(ghostArray![index].imageView)
                
                println("\(ghostArray!.count)")
                
                //draw stationary ghosts
                if index > ghostArrayCount/2 {
                    stationary = true
                }
            }
        }
    }
    
    
    //after a delay, show ghost and move it
    func move(timer: NSTimer) {
        
        /*var sizeRect = UIScreen.mainScreen().applicationFrame
        var x = sizeRect.size.width/2
        var y = sizeRect.size.height/2*/
        
        var x = self.view.center.x - size/2
        var y = self.view.center.y - size
        
        var random: Int = Int(arc4random_uniform(2))
        if( random < 1) {
            x -= 50
        }
        else {
            x += 50
        }
        random = Int(arc4random_uniform(2))
        if( random < 1) {
            y -= 50
        }
        else {
            y += 50
        }
        
        var position = CGRect(origin: CGPoint(x: CGFloat(x), y: CGFloat(y)), size: CGSize(width: size, height: size))
        
        //var position = CGRectMake(x, y, size, size)
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            //show ghost and move it
            
            self.ghostArray![self.currentIndex].imageView.hidden = false
            self.ghostArray![self.currentIndex].imageView.userInteractionEnabled = false
            self.ghostArray![self.currentIndex].imageView.frame = position
            
            },
            completion: { action in
                //attack pet
                if let ghostArray = self.ghostArray {
                    var ghost = self.ghostArray![self.attackIndex]
                    if( ghost.imageView.hidden == false) {
                        
                        
                        println("fire date: \(self.dateFormatter.stringFromDate(ghost.timer.fireDate))")
                        ghost.timer.fireDate = NSDate()
                        NSRunLoop.currentRunLoop().addTimer(ghost.timer, forMode: NSDefaultRunLoopMode)
                        println("fire date after: \(self.dateFormatter.stringFromDate(ghost.timer.fireDate))")
                        
                        println("attack index: \(self.attackIndex)")
                        println("time: \(self.dateFormatter.stringFromDate(NSDate()))")
                        
                    }
                    self.attackIndex++
                }
        })
        self.currentIndex++
    }
    
    //when ghost stops moving (animation completes)
    func attack(timer: NSTimer) {
        //var pet = RealmHelper.getRealmPet()!
        
        // RealmHelper.updateRealmPet(pet!.health-5)
        
        // pet!.health -= 5
        
        self.healthBar.setProgress(self.healthBar.progress-0.04, animated: false)
        if healthBar.progress <= 0 {
            displayDeadAlert()
            
            RealmHelper.resetPet()
        }
        
        println("attack!: \(dateFormatter.stringFromDate(NSDate()))")
    }
    
    
    //MARK: Gesture Recognizer Methods
    func detectTap(gesture: UITapGestureRecognizer) -> Int{
        
        if let ghostArray = ghostArray {
            for (index, ghost) in enumerate(ghostArray) {
                var tapLocation = gesture.locationInView(ghost.imageView.superview)
                if ghost.imageView.hidden == false {
                    if ghost.imageView.layer.presentationLayer().frame.contains(tapLocation) {
                        if(!ghost.dead) {
                            //println("id: \(ghost.id)")
                            ghost.dead = true
                            return ghost.id
                        }
                    }
                }
            }
        }
        return -1
    }
    
    func tappedGhost(recognizer: UITapGestureRecognizer) {
        
        // if(RealmHelper.getRealmState()!.state == "Defend") {
        var ghostID = detectTap(recognizer)
        
        if ghostID >= 0 {
            
            ghostArray![ghostID].imageView.hidden = true
            //user can no longer tap on ghost
            
            ghostArray![ghostID].imageView.userInteractionEnabled = false
            
            ghostArray![ghostID].timer.invalidate()
            
            ghostArrayCount--
            
            println("no of ghosts left: \(ghostArrayCount)")
            
            if ghostArrayCount == 0 {
                //RealmHelper.currentState = .Play
                RealmHelper.updateRealmState("Play")
                
                displayWinAlert()
                
                ghostArray = nil
                currentIndex = 0
                ghostArrayCount = 10
                attackIndex = 0
                stationary = false
                
                RealmHelper.updateRealmAlarmDidWin(true)
                
                RealmHelper.updateRealmPet(affection: 5)
                
                
                
                affectionLabel.setTitle("\(pet!.affection)", forState: UIControlState.Normal)
                currentState = .Play
                
                println("You win!")
                
            }
        }
    }
    
    
    
    func updatePetHealth() {
        //update pet health depending on the current time and alarm time
        let alarm = RealmHelper.getRealmAlarm()
        let pet = RealmHelper.getRealmPet()
        
        //difference in seconds between alarm time and when app is opened
        var difference = alarm!.time.timeIntervalSinceNow
        var health = Float((1000 + difference)/1000.0)
        println("health: \(health)")
        healthBar.progress = health
        
        if healthBar.progress <= 0 {
            displayDeadAlert()
            
            //show dead pet image
            //update in realm
            RealmHelper.resetPet()
            //remove ghosts (have them carry off pet?)
            
        }
        else {
            RealmHelper.updateRealmPet(Int(health*100))
        }
    }
    
    //MARK: Alerts
    func displayWinAlert() {
        
        let alertController = UIAlertController(title: "Congratulations!",
            message: "You defeated all the ghosts. Affection +5",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Yay!",
            style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func displayDeadAlert() {
        let alertController = UIAlertController(title: "Your pet died!",
            message: "Oh no :(",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "Revive Pet",
            style: UIAlertActionStyle.Default,
            handler: {action in
                
                self.healthBar.setProgress(1.0, animated: true)
                self.affectionLabel.setTitle("0 :(", forState: UIControlState.Normal)
                
                
        }))
        
        
        /*alertController.addAction(UIAlertAction(title: "Go to Funeral",
        style: UIAlertActionStyle.Default,
        handler: nil)) */
        
        self.presentViewController(alertController, animated: true, completion: {action in
            self.cancelTimers()
        })
    }
    
    func cancelTimers() {
        for (index, element) in enumerate(ghostArray!) {
            element.timer.invalidate()
        }
    }
    
    var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        return formatter
        }()
    
}

