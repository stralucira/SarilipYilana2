//
//  GameViewController.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 25/07/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, DataEnteredDelegate, ScoreboardDelegate {

    var data = GameData()
    
    //Sound Related
    var sarilipSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sarilip", ofType: "m4a")!)
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        try! audioPlayer = AVAudioPlayer(contentsOfURL: sarilipSound, fileTypeHint: "m4a")
        audioPlayer.prepareToPlay()
        
        anilButton.enabled = false

    }

    var claimOwnerString: String?
    
    var claimTruthBool: Bool?
    
    @IBOutlet weak var remainingClaims: UILabel!
    
    private var remainingClaimValue: Int {
        
        get{
            return Int(remainingClaims.text!)!
        }
        set{
            remainingClaims.text = String(newValue)
        }
    }

    @IBOutlet weak var anilButton: UIButton!
    @IBOutlet weak var claimTruth: UILabel!
    @IBOutlet weak var claimOwner: UILabel!
    @IBOutlet weak var claimLabel: UILabel!
    @IBOutlet weak var showClaimButton: UIButton!
    
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    
    @IBAction func newGame(sender: UIBarButtonItem) {
        
        let newGameAlert = UIAlertController(title: "New Game", message: "All your data will be lost", preferredStyle: UIAlertControllerStyle.Alert)
        
        newGameAlert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(action: UIAlertAction!) in
        
            self.data.clear()
            self.clearDisplays()
            
        }))
        newGameAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action: UIAlertAction!) in
        
        }))
        
        presentViewController(newGameAlert, animated: true, completion: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "makeYourClaims" {
            let secondViewController = segue.destinationViewController as! LaunchViewController
            secondViewController.delegate = self
        } else if segue.identifier == "showScoreboard" {
            let second = segue.destinationViewController as! ScoreboardViewController
            second.delegate = self
            second.scoreData = data.scores
        }
    }

    
    @IBAction func showLeaderboardButton(sender: UIBarButtonItem) {
    
    }
    //Used for DataEnteredDelegate
    func userDidEnterInformation(claim: Claim) {
        
        data.addClaim(claim.name, sentence: claim.sentence, truthfulness: claim.truthfulness)
        
        data.addPlayer(claim.name)
        
        remainingClaimValue = data.claimCount
        
    }
    
    func increaseUserScore(user: String, byScore score: Int){
        
        if (score == 1) {
            data.addPoint(user)
        } else if (score == 2) {
            data.addYilanPoint(user)
        } else if (score == -1) {
            
            if (data.scores[user] > 0 ){
                data.subtractPoint(user)
            }
        }
    }
    
    @IBAction func showClaim(sender: UIButton) {
        
        if (data.claimCount != 0 ) {
        claimOwner.text = nil
        claimTruth.text = nil
        
        let claimToBeShowed = data.randomClaim()
        
        claimLabel.text = "\"\(claimToBeShowed.sentence)\""
        
        claimOwnerString = claimToBeShowed.name
        claimTruthBool = claimToBeShowed.truthfulness
        
        remainingClaimValue = data.claimCount
            
        audioPlayer.play()
            
        anilButton.enabled = true
        showClaimButton.enabled = false
        }
        
        
    }
    
    @IBAction func reveal(sender: AnyObject) {
        
        if let temp = claimOwnerString{
            claimOwner.text = " - \(temp)"
        }
        
        if let tempBool = claimTruthBool {
            
            if (tempBool){
                claimTruth.textColor = UIColor.greenColor()
                claimTruth.text = "True"
                
            } else {
                claimTruth.textColor = UIColor.redColor()
                claimTruth.text = "False"
            }
        }
        showClaimButton.enabled = true
        anilButton.enabled = false
    }
    
    func clearDisplays() {
        remainingClaimValue = 0
        claimTruth.text = ""
        claimLabel.text = "Welcome to Sarılıp Yılana"
        claimOwner.text = ""
        claimOwnerString = nil
        claimTruthBool = nil
        
        anilButton.enabled = false
        showClaimButton.enabled = true
    }
    
}
