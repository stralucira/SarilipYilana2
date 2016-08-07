//
//  LaunchViewController.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 24/07/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

protocol DataEnteredDelegate: class {
    
    func userDidEnterInformation(claim: Claim)

}

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LaunchViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    var successfulClaims: Int = 0
    var successMessage = ""
    var titleMessage = ""
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    weak var delegate: DataEnteredDelegate? = nil
    
    @IBOutlet weak var playerName: UITextField!
    
    @IBOutlet weak var sentenceOne: UITextField!
    @IBOutlet weak var truthOne: UISwitch!
    
    @IBOutlet weak var sentenceTwo: UITextField!
    @IBOutlet weak var truthTwo: UISwitch!
    
    @IBOutlet weak var sentenceThree: UITextField!
    @IBOutlet weak var truthThree: UISwitch!
    
    @IBAction func save(sender: UIButton) {
    
        if (playerName.text != "") && ((sentenceOne.text !=  "") || (sentenceTwo.text !=  "") || (sentenceThree.text !=  "")){
            
            if (sentenceOne.text != "") {
                delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceOne.text!, truthfulness: truthOne.on))
                successfulClaims += 1
            }
        
            if (sentenceTwo.text != "") {
                delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceTwo.text!, truthfulness: truthTwo.on))
                successfulClaims += 1
            }
        
            if (sentenceThree.text != "") {
                delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceThree.text!, truthfulness: truthThree.on))
                successfulClaims += 1
            }
            
            if ( successfulClaims == 1 ) {
                successMessage = "Your 1 claim has been submitted."
                titleMessage = "Gratz \(playerName.text!)!"
            } else {
                successMessage = "Your \(successfulClaims) claims has been submitted."
                titleMessage = "Gratz \(playerName.text!)!"
            }
            
            let successAlertController = UIAlertController(title: titleMessage, message:
                successMessage, preferredStyle: UIAlertControllerStyle.Alert)
            successAlertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
        
            self.presentViewController(successAlertController, animated: true, completion: nil)
        
            clear()
            
        } else if (playerName.text == "") {
            
            let nameNotEnteredAlertController = UIAlertController(title: "", message:
                "Please type your name before submitting!", preferredStyle: UIAlertControllerStyle.Alert)
            nameNotEnteredAlertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(nameNotEnteredAlertController, animated: true, completion: nil)
            
        } else if (((sentenceOne.text == "") && (sentenceTwo.text == "")) && (sentenceThree.text == "")) {
            
            let claimNotEnteredAlertController = UIAlertController(title: "", message:
                "You have not entered any claims!", preferredStyle: UIAlertControllerStyle.Alert)
            claimNotEnteredAlertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(claimNotEnteredAlertController, animated: true, completion: nil)
            
        }
        
    }
    
    //Clear function
    func clear() {
        
        playerName.text = nil
        sentenceOne.text = nil
        sentenceTwo.text = nil
        sentenceThree.text = nil
        
        truthOne.on = true
        truthTwo.on = true
        truthThree.on = true
        
        successfulClaims = 0
        
    }
    
}
