//
//  GhostViewController.swift
//  AlarmPet
//
//  Created by Rebecca Poch on 7/17/15.
//  Copyright (c) 2015 Rebecca Poch. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

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
    
    var brightness: CGFloat = UIScreen.mainScreen().brightness
    var currentTime: NSDate = NSDate()
    
    var soundFileObject: SystemSoundID = 0
    let healPathURL: NSURL = NSBundle.mainBundle().URLForResource("heal", withExtension: "wav")!
    var soundFileObjectHeal: SystemSoundID = 0
    var soundFileObjectApplause: SystemSoundID = 0
    var soundFileObjectBoo: SystemSoundID = 0
    
    @IBOutlet weak var affectionLabel: UIButton!
    
    @IBOutlet weak var surpriseLabel: UILabel!
    
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
        willSet {
            switch(currentState) {
                
            case .Play:
                surpriseLabel.hidden = true
                
            default:
                println("default")
            }
        }
        
        didSet {
            switch(currentState) {
                
            case .Defend:
                
                NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: "increaseBrightness:", userInfo: nil, repeats: true)
                petImageView.userInteractionEnabled = false
                
                surpriseLabel.hidden = false
                
                petImageView.image = UIImage(named: "Pet-Hurt")
                
            case .Play:
                println("PLAY")
                petImageView.userInteractionEnabled = true
                surpriseLabel.hidden = true
                
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                self.petImageView.image = UIImage(named: "Pet")
                
            default:
                println("default")
            }
        }
    }
    
    func increaseBrightness(timer: NSTimer) {
        brightness += 0.0001
        UIScreen.mainScreen().brightness = brightness
        if brightness >= 1.0 {
            timer.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthBar.progress = 1.0
        
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: "healPet:")
        petImageView.addGestureRecognizer(pan)
    }
    
    func healPet(recognizer: UIPanGestureRecognizer) {
        
        if healthBar.progress < 1{
            //create sound ID
            if recognizer.state == UIGestureRecognizerState.Began {
                AudioServicesCreateSystemSoundID(healPathURL as CFURL, &soundFileObjectHeal)
                AudioServicesPlaySystemSound(soundFileObjectHeal)
                currentTime = NSDate()
            }
            
            //moving finger
            var velocity = recognizer.velocityInView(self.view)
            if velocity.x > 0 || velocity.y > 0 {
                
                self.petImageView.image = UIImage(named: "Pet-Happy")
                
                healthBar.progress += 0.001
                //println("healing")
                
                //println("\(currentTime.timeIntervalSinceNow)")
                //check within  8 seconds of last sound
                if currentTime.timeIntervalSinceNow < -8 {
                    AudioServicesPlaySystemSound(soundFileObjectHeal)
                    currentTime = NSDate()
                    println("heal sound")
                    
                }
            }
            
        }
        //stop playing sound
        if recognizer.state == UIGestureRecognizerState.Ended {
            
            AudioServicesDisposeSystemSoundID(soundFileObjectHeal)
            self.petImageView.image = UIImage(named: "Pet")
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
            let swipe = self.view.gestureRecognizers![1] as! UIPanGestureRecognizer
            
            
            tap.addTarget(self, action: "tappedGhost:")
            self.view.addGestureRecognizer(tap)
            
            swipe.addTarget(self, action: "swipedGhost:")
            self.view.addGestureRecognizer(swipe)
            
            ghostArray = []
            
            for index in 0...ghostArrayCount-1 {
                
                var delay = NSTimeInterval(index)
                
                //NSRunLoop.currentRunLoop().addTimer(temp[0].timer, forMode: NSDefaultRunLoopMode)
                
                
                var random = arc4random_uniform(2)
                var weakness: String = ""
                if random == 0 {
                    weakness = "Tap"
                }
                else {
                    weakness = "Swipe"
                }
                
                var temp = Ghost(id: index,
                    timer: NSTimer(timeInterval: 5, target: self, selector: "attack:", userInfo: nil, repeats: true),
                    weakness: weakness)
                
                var x: CGFloat = 0
                var y: CGFloat = 0
                
                if !stationary {
                    
                    var random: Int = Int(arc4random_uniform(3))
                    if( random == 1) {
                        x = 0
                    }
                    else if random == 2{
                        x = self.view.bounds.width - size
                    }
                    else {
                        x = self.view.bounds.width/2
                    }
                    random = Int(arc4random_uniform(3))
                    if( random == 1) {
                        y = 0
                    }
                    else if random == 2{
                        y = self.view.bounds.height - size
                    }
                    else {
                        y = self.view.bounds.height/2
                    }
                    
                    
                }
                
                //if ghosts do not move
                if stationary {
                    temp.imageView.userInteractionEnabled = true
                    temp.imageView.hidden = false
                    
                    //x = self.view.center.x - size/2
                    //y = self.view.center.y - size
                    x = self.view.bounds.width/2 - size/2
                    y = self.view.bounds.height/2 - size
                    var offset = CGFloat(75)
                    
                    if index == 7 {
                        x -= offset
                    }
                    else if index == 8 {
                        x += offset
                    }
                    else if index == 9 {
                        y -= offset
                    }
                    else if index == 10 {
                        y += offset
                    }
                    
                    temp.timer.fireDate = NSDate().dateByAddingTimeInterval(delay/2)
                    
                    NSRunLoop.currentRunLoop().addTimer(temp.timer, forMode: NSDefaultRunLoopMode)
                    
                    NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "move:", userInfo: nil, repeats: false)
                }
                    
                else {
                    
                    NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: "move:", userInfo: nil, repeats: false)
                    
                    temp.imageView.userInteractionEnabled = false
                    temp.imageView.hidden = true
                }
                
                temp.imageView.frame = CGRect(x: x, y: y, width: size, height: size)
                
                ghostArray!.append(temp)
                
                self.view.addSubview(ghostArray![index].imageView)
                
                println("\(ghostArray!.count)")
                
                //draw stationary ghosts
                /*if index >ghostArrayCount/2 {
                stationary = true
                }
                */
                if index == 6 {
                    stationary = true
                }
                
            }
        }
    }
    
    
    //after a delay, show ghost and move it
    func move(timer: NSTimer) {
        
        var x = self.view.center.x - size/2
        var y = self.view.center.y - size
        
        if currentIndex == 0 {
            x -= 50
            y -= 50
        }
        else if currentIndex == 1 {
            x -= 50
            y += 50
        }
        else if currentIndex == 2 {
            x += 50
            y -= 50
        }
        else if currentIndex == 3 {
            x += 50
            y += 50
        }
        else if currentIndex == 4 {
            x += 75
            y += 75
        }
        else if currentIndex == 5 {
            x -= 75
            y += 75
        }
        else if currentIndex == 6 {
            x -= 75
            y -= 75
        }
        
        
        var position = CGRect(origin: CGPoint(x: CGFloat(x), y: CGFloat(y)), size: CGSize(width: size, height: size))
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            //show ghost and move it
            
            //stationary case
            
            if self.currentIndex < 7 {
                self.ghostArray![self.currentIndex].imageView.hidden = false
                self.ghostArray![self.currentIndex].imageView.userInteractionEnabled = false
            }
            self.ghostArray![self.currentIndex].imageView.frame = position
            
            
            },
            completion: { action in
                //attack pet
                if let ghostArray = self.ghostArray {
                    var ghost = self.ghostArray![self.attackIndex]
                    if( ghost.imageView.hidden == false) {
                        
                        ghost.timer.fireDate = NSDate()
                        NSRunLoop.currentRunLoop().addTimer(ghost.timer, forMode: NSDefaultRunLoopMode)
                        
                        //println("attack index: \(self.attackIndex)")
                        
                        ghost.imageView.startAnimating()
                        
                    }
                    self.attackIndex++
                }
        })
        
        
        self.currentIndex++
    }
    func moveStationary(timer: NSTimer) {
        var x = self.view.center.x - size/2
        var y = self.view.center.y - size
    }
    
    //when ghost stops moving (animation completes)
    func attack(timer: NSTimer) {
        //var pet = RealmHelper.getRealmPet()!
        
        // RealmHelper.updateRealmPet(pet!.health-5)
        
        // pet!.health -= 5
        
        
        let pathURL: NSURL = NSBundle.mainBundle().URLForResource("attack2", withExtension: "wav")!
        AudioServicesCreateSystemSoundID(pathURL as CFURL, &soundFileObject)
        
        AudioServicesPlaySystemSound(soundFileObject)
        
        
        self.healthBar.setProgress(self.healthBar.progress-0.04, animated: false)
        if healthBar.progress <= 0 {
            cancelTimers()
            deadAlert()
            
            RealmHelper.resetPet()
        }
        
        //println("attack!: \(dateFormatter.stringFromDate(NSDate()))")
        
        self.petImageView.image = UIImage(named: "Pet-Hurt")
        
        NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: "revertImage:", userInfo: nil, repeats: false)
        
    }
    
    func revertImage(timer: NSTimer) {
        self.petImageView.image = UIImage(named: "Pet")
    }
    
    
    
    //MARK: Gesture Recognizer Methods
    func detectTap(gesture: UITapGestureRecognizer) -> Int{
        
        if let ghostArray = ghostArray {
            for (index, ghost) in enumerate(ghostArray) {
                if ghost.weakness == "Tap" {
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
        }
        return -1
    }
    
    func tappedGhost(recognizer: UITapGestureRecognizer) {
        
        var ghostID = detectTap(recognizer)
        
        if ghostID >= 0 {
            
            ghostArray![ghostID].imageView.hidden = true
            //user can no longer tap on ghost
            
            ghostArray![ghostID].imageView.userInteractionEnabled = false
            
            ghostArray![ghostID].timer.invalidate()
            
            println("ghostID: \(ghostID)")
            
            ghostArrayCount--
            
            println("no of ghosts left: \(ghostArrayCount)")
            
            if ghostArrayCount == 0 {
                //RealmHelper.currentState = .Play
                RealmHelper.updateRealmState("Play")
                
                //displayWinAlert()
                winAlert()
                
                ghostArray = nil
                currentIndex = 0
                ghostArrayCount = 10
                attackIndex = 0
                stationary = false
                
                RealmHelper.updateRealmAlarmDidWin(true)
                
                RealmHelper.updateRealmPet(affection: 5)
                
                AudioServicesDisposeSystemSoundID(self.soundFileObject)
                
                affectionLabel.setTitle("\(pet!.affection)", forState: UIControlState.Normal)
                
                currentState = .Play
                
                println("You win!")
                
            }
        }
    }
    
    func swipedGhost(recognizer: UIPanGestureRecognizer) {
        
        var ghostID = detectSwipe(recognizer)
        
        if ghostID >= 0 {
            
            ghostArray![ghostID].imageView.hidden = true
            //user can no longer tap on ghost
            
            ghostArray![ghostID].imageView.userInteractionEnabled = false
            
            ghostArray![ghostID].timer.invalidate()
            
            println("ghostID: \(ghostID)")
            
            ghostArrayCount--
            
            println("no of ghosts left: \(ghostArrayCount)")
            
            if ghostArrayCount == 0 {
                //RealmHelper.currentState = .Play
                RealmHelper.updateRealmState("Play")
                
                //displayWinAlert()
                winAlert()
                
                ghostArray = nil
                currentIndex = 0
                ghostArrayCount = 10
                attackIndex = 0
                stationary = false
                
                RealmHelper.updateRealmAlarmDidWin(true)
                
                RealmHelper.updateRealmPet(affection: 5)
                
                AudioServicesDisposeSystemSoundID(self.soundFileObject)
                
                affectionLabel.setTitle("\(pet!.affection)", forState: UIControlState.Normal)
                
                currentState = .Play
                
                println("You win!")
                
            }
        }
        
    }
    
    func detectSwipe(gesture: UIPanGestureRecognizer) -> Int{
        
        if let ghostArray = ghostArray {
            for (index, ghost) in enumerate(ghostArray) {
                if ghost.weakness == "Swipe" {
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
        }
        return -1
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
            deadAlert()
            
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
    /**
    Uses JSSAlertView from Jay Stakelon / https://github.com/stakes
    
    */
    
    func winAlert() {
        
        
        let pathURL: NSURL = NSBundle.mainBundle().URLForResource("applause", withExtension: "wav")!
        AudioServicesCreateSystemSoundID(pathURL as CFURL, &soundFileObjectApplause)
        
        AudioServicesPlaySystemSound(soundFileObjectApplause)
        
        
        var alertView = JSSAlertView().show(self,
            
            title: "Congratulations!",
            text: "You defeated all the ghosts. \n Affection +5",
            buttonText: "Yay!",
            color: UIColorFromHex(0x9b59b6,
                alpha: 1)
        )
        
        alertView.addAction(completionCallbackWin)
        alertView.setTitleFont("Avenir-Book") // Title font
        alertView.setTextFont("Avenir-Book") // Alert body text font
        alertView.setButtonFont("Avenir-Book") // Button text font
        alertView.setTextTheme(.Light) // can be .Light or .Dark
        
    }
    
    func completionCallbackWin() {
        
        AudioServicesDisposeSystemSoundID(soundFileObjectApplause)
    }
    
    func deadAlert() {
        
        let pathURL: NSURL = NSBundle.mainBundle().URLForResource("boo", withExtension: "wav")!
        AudioServicesCreateSystemSoundID(pathURL as CFURL, &soundFileObjectBoo)
        
        AudioServicesPlaySystemSound(soundFileObjectBoo)
        
        
        var alertView = JSSAlertView().danger(self,
            title: "Your pet died!",
            text: "Oh no :(",
            buttonText: "Revive Pet"
            //color: UIColorFromHex(0x9b59b6,
            //  alpha: 1)
            
        )
        
        alertView.addAction(completionCallbackLose)
        alertView.setTitleFont("Avenir-Book") // Title font
        alertView.setTextFont("Avenir-Book") // Alert body text font
        alertView.setButtonFont("Avenir-Book") // Button text font
        alertView.setTextTheme(.Light) // can be .Light or .Dark
        
    }
    
    func completionCallbackLose() {
        self.healthBar.setProgress(1.0, animated: true)
        self.affectionLabel.setTitle("0 :(", forState: UIControlState.Normal)
        
        AudioServicesDisposeSystemSoundID(soundFileObjectBoo)
    }
    
    
    func displayWinAlert() {
        
        var soundFileObjectApplause: SystemSoundID = 0
        
        let alertController = UIAlertController(title: "Congratulations!",
            message: "You defeated all the ghosts. \n Affection +5",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Yay!",
            style: UIAlertActionStyle.Default,
            handler: {action in
                
                AudioServicesDisposeSystemSoundID(soundFileObjectApplause)
        }))
        
        self.presentViewController(alertController, animated: true, completion: {action in
            
            
            
            let pathURL: NSURL = NSBundle.mainBundle().URLForResource("applause", withExtension: "wav")!
            AudioServicesCreateSystemSoundID(pathURL as CFURL, &soundFileObjectApplause)
            
            AudioServicesPlaySystemSound(soundFileObjectApplause)
            
            
            
        })
    }
    
    
    func displayDeadAlert() {
        
        var soundFileObjectBoo: SystemSoundID = 0
        
        let alertController = UIAlertController(title: "Your pet died!",
            message: "Oh no :(",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "Revive Pet",
            style: UIAlertActionStyle.Default,
            handler: {action in
                
                self.healthBar.setProgress(1.0, animated: true)
                self.affectionLabel.setTitle("0 :(", forState: UIControlState.Normal)
                
                AudioServicesDisposeSystemSoundID(soundFileObjectBoo)
        }))
        
        
        /*alertController.addAction(UIAlertAction(title: "Go to Funeral",
        style: UIAlertActionStyle.Default,
        handler: nil)) */
        
        self.presentViewController(alertController, animated: true, completion: {action in
            self.cancelTimers()
            
            
            let pathURL: NSURL = NSBundle.mainBundle().URLForResource("boo", withExtension: "wav")!
            AudioServicesCreateSystemSoundID(pathURL as CFURL, &soundFileObjectBoo)
            
            AudioServicesPlaySystemSound(soundFileObjectBoo)
            
            
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

