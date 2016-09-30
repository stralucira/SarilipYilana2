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

@IBDesignable
class LaunchViewController: UIViewController {

    let greenColor = UIColor( red: 6/255, green: 138/255, blue:0/255, alpha: 1.0 ).CGColor
    
    let redColor = UIColor( red: 156/255, green: 0/255, blue:0/255, alpha: 1.0 ).CGColor
    
    let mySwitch = SevenSwitch(frame: CGRectZero)
    let mySwitch2 = SevenSwitch(frame: CGRectZero)
    let mySwitch3 = SevenSwitch(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mySwitch.frame = CGRectMake(290, 150, 80, 33)
        mySwitch2.frame = CGRectMake(290, 201, 80, 33)
        mySwitch3.frame = CGRectMake(290, 252, 80, 33)
        switchHandler(mySwitch)
        switchHandler(mySwitch2)
        switchHandler(mySwitch3)
        mySwitch.addTarget(self, action: #selector(LaunchViewController.switchOne(_:)), forControlEvents: UIControlEvents.ValueChanged)
        mySwitch2.addTarget(self, action: #selector(LaunchViewController.switchTwo(_:)), forControlEvents: UIControlEvents.ValueChanged)
        mySwitch3.addTarget(self, action: #selector(LaunchViewController.switchThree(_:)), forControlEvents: UIControlEvents.ValueChanged)


        self.view.addSubview(mySwitch)
        self.view.addSubview(mySwitch2)
        self.view.addSubview(mySwitch3)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LaunchViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        sentenceOne.layer.cornerRadius = 10.0
        sentenceOne.layer.masksToBounds = true
        sentenceOne.layer.borderColor = greenColor
        sentenceOne.layer.borderWidth = 2
        
        sentenceTwo.layer.cornerRadius = 10.0
        sentenceTwo.layer.masksToBounds = true
        sentenceTwo.layer.borderColor = greenColor
        sentenceTwo.layer.borderWidth = 2
        
        sentenceThree.layer.cornerRadius = 10.0
        sentenceThree.layer.masksToBounds = true
        sentenceThree.layer.borderColor = greenColor
        sentenceThree.layer.borderWidth = 2
        
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
    
    func switchOne(sender: SevenSwitch) {
        if ( sender.isOn() == false ) {
            sentenceOne.layer.borderColor = redColor
        } else {
            sentenceOne.layer.borderColor = greenColor
        }
    }
    
    @IBOutlet weak var sentenceTwo: UITextField!
    @IBOutlet weak var truthTwo: UISwitch!
    
    @IBAction func switchTwo(sender: SevenSwitch) {
        
        if ( sender.isOn() == false ) {
            sentenceTwo.layer.borderColor = redColor
        } else {
            sentenceTwo.layer.borderColor = greenColor
        }
        
    }
    
    
    @IBOutlet weak var sentenceThree: UITextField!
    @IBOutlet weak var truthThree: UISwitch!
    
    @IBAction func switchThree(sender: SevenSwitch) {
        
        if ( sender.isOn() == false ) {
            sentenceThree.layer.borderColor = redColor
        } else {
            sentenceThree.layer.borderColor = greenColor
        }
        
    }
    
    
    
    @IBAction func save(sender: UIButton) {
    
        if (playerName.text != "") && ((sentenceOne.text !=  "") || (sentenceTwo.text !=  "") || (sentenceThree.text !=  "")){
            
            if (sentenceOne.text != "") {
                delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceOne.text!, truthfulness: mySwitch.isOn()))
                successfulClaims += 1
            }
        
            if (sentenceTwo.text != "") {
                delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceTwo.text!, truthfulness: mySwitch2.isOn()))
                successfulClaims += 1
            }
        
            if (sentenceThree.text != "") {
                delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceThree.text!, truthfulness: mySwitch3.isOn()))
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
    
    func switchHandler(mySwitch: SevenSwitch) -> Void {
        
        mySwitch.offLabel.text = "FALSE"
        mySwitch.offLabel.textColor = UIColor.whiteColor()
        mySwitch.onLabel.textColor = UIColor.whiteColor()
        mySwitch.inactiveColor =  UIColor( red: 156/255, green: 0/255, blue:0/255, alpha: 1.0 )
        mySwitch.activeColor = UIColor( red: 6/255, green: 138/255, blue:0/255, alpha: 1.0 )
        mySwitch.tintColor = UIColor.clearColor()
        mySwitch.thumbImage = UIImage(named: "iconsnake")
        mySwitch.on = true
        mySwitch.onLabel.text = "TRUE"

        
    }
    
    //Clear function
    func clear() {
        
        playerName.text = nil
        sentenceOne.text = nil
        sentenceTwo.text = nil
        sentenceThree.text = nil
        
        mySwitch.on = true
        mySwitch2.on = true
        mySwitch3.on = true
        
        successfulClaims = 0
        
    }
    
}
