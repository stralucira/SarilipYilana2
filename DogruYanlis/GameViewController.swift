//
//  GameViewController.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 25/07/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, DataEnteredDelegate {

    var data = GameData()
    
    var sarilipSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sarilip", ofType: "m4a")!)
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        try! audioPlayer = AVAudioPlayer(contentsOfURL: sarilipSound, fileTypeHint: "m4a")
        audioPlayer.prepareToPlay()

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

    @IBOutlet weak var claimTruth: UILabel!
    @IBOutlet weak var claimOwner: UILabel!
    @IBOutlet weak var claimLabel: UILabel!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "makeYourClaims" {
            let secondViewController = segue.destinationViewController as! LaunchViewController
            secondViewController.delegate = self
        }
    }

    func userDidEnterInformation(claim: Claim) {
        
        data.addClaim(claim.name, sentence: claim.sentence, truthfulness: claim.truthfulness)
        
        remainingClaimValue = data.claimCount
        
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
            
        }
    }
    
    @IBAction func reveal(sender: AnyObject) {
        if let temp = claimOwnerString{
            claimOwner.text = " - \(temp)"
        }
        
        if let tempBool = claimTruthBool {
            
            if (tempBool){
                claimTruth.text = "True"
            } else {
                claimTruth.text = "False"
            }
        }
    }
}
