//
//  GameViewController.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 25/07/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import Foundation


class GameViewController: UIViewController, DataEnteredDelegate, ScoreboardDelegate {

    var data = GameData()
    
    lazy var ref: DatabaseReference = Database.database().reference()
    var usersRef: DatabaseReference!
    
    //Sound Related
    //var sarilipSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sarilip", ofType: "m4a")!)
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let sarilipSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "sarilip", ofType: "m4a")!)
        try! audioPlayer = AVAudioPlayer(contentsOf: sarilipSound as URL, fileTypeHint: "m4a")
        audioPlayer.prepareToPlay()
        anilButton.isEnabled = false
        
        usersRef = ref.child("sessions/\(data.gameID)/users")
    }

    var claimOwnerString: String?
    
    var claimTruthBool: Bool?
    
    @IBOutlet weak var remainingClaims: UILabel!
    
    private var remainingClaimValue: Int {
        
        get{
            let remainingClaimValueString = remainingClaims.text!.components(separatedBy: " ")
            return Int(remainingClaimValueString[0])!
        }
        set{
            remainingClaims.text = String(newValue) + " Claims Left"
        }
    }

    @IBOutlet weak var anilButton: UIButton!
    @IBOutlet weak var claimTruth: UILabel!
    @IBOutlet weak var claimOwner: UILabel!
    @IBOutlet weak var claimLabel: UILabel!
    @IBOutlet weak var showClaimButton: UIButton!
    
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    
    @IBAction func newGame(_ sender: UIBarButtonItem) {
        
        let newGameAlert = UIAlertController(title: "Quit", message: "Are you sure you want to quit game?", preferredStyle: UIAlertController.Style.alert)
        
        newGameAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
            self.data.clear()
            self.clearDisplays()
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "quitGame", sender: self)
        }))
        
        newGameAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action: UIAlertAction!) in
        }))
        
        present(newGameAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makeYourClaims" {
            let secondViewController = segue.destination as! AddClaimsViewController
            secondViewController.delegate = self
        } else if segue.identifier == "showScoreboard" {
            let second = segue.destination as! ScoreboardViewController
            second.delegate = self
            second.scoreData = data.scores
        }
    }

    @IBAction func showLeaderboardButton(_ sender: UIBarButtonItem) {
    }
    
    //Used for DataEnteredDelegate
    func userDidEnterInformation(claim: Claim) {
        data.addClaim(senderName: claim.name, sentence: claim.sentence, truthfulness: claim.truthfulness)
        data.addPlayer(name: claim.name)
        remainingClaimValue = data.claimCount
    }
    
    func increaseUserScore(name user: String, byScore score: Int){
        if (score == 1) {
            data.addPoint(name: user)
        } else if (score == 2) {
            data.addYilanPoint(name: user)
        } else if (score == -1) {
            if (data.scores[user]! > 0 ){
                data.subtractPoint(name: user)
            }
        }
    }
    
    @IBAction func showClaim(_ sender: UIButton) {
        
        if (data.claimCount != 0 ) {
        claimOwner.text = nil
        claimTruth.text = nil
        
        let claimToBeShowed = data.randomClaim()
        
        claimLabel.text = "\"\(claimToBeShowed.sentence)\""
        
        claimOwnerString = claimToBeShowed.name
        claimTruthBool = claimToBeShowed.truthfulness
        
        remainingClaimValue = data.claimCount
            
        audioPlayer.play()
            
        anilButton.isEnabled = true
        showClaimButton.isEnabled = false
        }
    }
    
    @IBAction func reveal(_ sender: AnyObject) {
        if let temp = claimOwnerString{
            claimOwner.text = " - \(temp)"
        }
        if let tempBool = claimTruthBool {
            
            if (tempBool){
                claimTruth.textColor = UIColor.green
                claimTruth.text = "True"
            } else {
                claimTruth.textColor = UIColor.red
                claimTruth.text = "False"
            }
        }
        showClaimButton.isEnabled = true
        anilButton.isEnabled = false
    }
    
    func clearDisplays() {
        remainingClaimValue = 0
        claimTruth.text = ""
        claimLabel.text = "Welcome to Sarılıp Yılana"
        claimOwner.text = ""
        claimOwnerString = nil
        claimTruthBool = nil
        
        anilButton.isEnabled = false
        showClaimButton.isEnabled = true
    }
}
