//
//  AddClaimsViewController.swift
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
class AddClaimsViewController: UIViewController {

    let _greenColor = UIColor( red: 18/255, green: 136/255, blue: 2/255, alpha: 1.0 )
    let greenColor = UIColor( red: 18/255, green: 136/255, blue: 2/255, alpha: 1.0 ).cgColor
    
    let _redColor = UIColor( red: 156/255, green: 0/255, blue: 0/255, alpha: 1.0 )
    let redColor = UIColor( red: 156/255, green: 0/255, blue: 0/255, alpha: 1.0 ).cgColor
    
    let mySwitch = SevenSwitch(frame: CGRect.zero)
    let mySwitch2 = SevenSwitch(frame: CGRect.zero)
    let mySwitch3 = SevenSwitch(frame: CGRect.zero)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        mySwitch.frame = CGRect(x: 290, y: 150, width: 80, height: 33)
        mySwitch2.frame = CGRect(x: 290, y: 201, width: 80, height: 33)
        mySwitch3.frame = CGRect(x: 290, y: 252, width: 80, height: 33)
        switchHandler(mySwitch: mySwitch)
        switchHandler(mySwitch: mySwitch2)
        switchHandler(mySwitch: mySwitch3)
        mySwitch.addTarget(self, action: #selector(AddClaimsViewController.switchOne(sender:)), for: UIControl.Event.valueChanged)
        mySwitch2.addTarget(self, action: #selector(AddClaimsViewController.switchTwo(sender:)), for: UIControl.Event.valueChanged)
        mySwitch3.addTarget(self, action: #selector(AddClaimsViewController.switchThree(sender:)), for: UIControl.Event.valueChanged)

        self.view.addSubview(mySwitch)
        self.view.addSubview(mySwitch2)
        self.view.addSubview(mySwitch3)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddClaimsViewController.dismissKeyboard))
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
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    weak var delegate: DataEnteredDelegate? = nil
    
    @IBOutlet weak var playerName: UITextField!
    
    @IBOutlet weak var sentenceOne: UITextField!
    
    @objc func switchOne(sender: SevenSwitch) {
        if ( sender.isOn() == false ) {
            sentenceOne.layer.borderColor = redColor
        } else {
            sentenceOne.layer.borderColor = greenColor
        }
    }
    
    @IBOutlet weak var sentenceTwo: UITextField!
    
    @objc func switchTwo(sender: SevenSwitch) {
        
        if ( sender.isOn() == false ) {
            sentenceTwo.layer.borderColor = redColor
        } else {
            sentenceTwo.layer.borderColor = greenColor
        }
        
    }
    
    
    @IBOutlet weak var sentenceThree: UITextField!
    
    @objc func switchThree(sender: SevenSwitch) {
        
        if ( sender.isOn() == false ) {
            sentenceThree.layer.borderColor = redColor
        } else {
            sentenceThree.layer.borderColor = greenColor
        }
        
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        
        if (playerName.text != "") && ((sentenceOne.text !=  "") || (sentenceTwo.text !=  "") || (sentenceThree.text !=  "")){
            
            if (sentenceOne.text != "") {
                delegate?.userDidEnterInformation(claim: Claim(name: playerName.text!, sentence: sentenceOne.text!, truthfulness: mySwitch.isOn()))
                successfulClaims += 1
            }
            
            if (sentenceTwo.text != "") {
                delegate?.userDidEnterInformation(claim: Claim(name: playerName.text!, sentence: sentenceTwo.text!, truthfulness: mySwitch2.isOn()))
                successfulClaims += 1
            }
            
            if (sentenceThree.text != "") {
                delegate?.userDidEnterInformation(claim: Claim(name: playerName.text!, sentence: sentenceThree.text!, truthfulness: mySwitch3.isOn()))
                successfulClaims += 1
            }
            
            if (successfulClaims == 1) {
                successMessage = "Your 1 claim has been submitted."
                titleMessage = "Gratz \(playerName.text!)!"
                
            } else {
                successMessage = "Your \(successfulClaims) claims has been submitted."
                titleMessage = "Gratz \(playerName.text!)!"
            }
            
            let successAlertController = UIAlertController(
                title: titleMessage,
                message: successMessage,
                preferredStyle: UIAlertController.Style.alert
            )
            
            successAlertController.addAction(
                UIAlertAction(
                    title: "Okay",
                    style: UIAlertAction.Style.default,
                    handler: { (successAlertController) in
                        _ = self.navigationController?.popViewController(animated: true)
                }
                )
            )
            
            self.present(successAlertController, animated: true, completion: nil)
            
            clear()
            
        } else if (playerName.text == "") {
            
            let nameNotEnteredAlertController = UIAlertController(title: "", message:
                "Please type your name before submitting!", preferredStyle: UIAlertController.Style.alert)
            
            nameNotEnteredAlertController.addAction(
                UIAlertAction(
                    title: "Okay",
                    style: UIAlertAction.Style.default,
                    handler: nil
                )
            )
            
            self.present(nameNotEnteredAlertController, animated: true, completion: nil)
            
        } else if (((sentenceOne.text == "") && (sentenceTwo.text == "")) && (sentenceThree.text == "")) {
            
            let claimNotEnteredAlertController = UIAlertController(title: "", message:
                "You have not entered any claims!", preferredStyle: UIAlertController.Style.alert)
            claimNotEnteredAlertController.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(claimNotEnteredAlertController, animated: true, completion: nil)
            
        }
        
    }
    
    func switchHandler(mySwitch: SevenSwitch) -> Void {
        
        mySwitch.offLabel.text = "FALSE"
        mySwitch.offLabel.textColor = UIColor.white
        mySwitch.onLabel.textColor = UIColor.white
        mySwitch.inactiveColor =  _redColor
        mySwitch.activeColor = _greenColor
        mySwitch.tintColor = UIColor.clear
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
        
        sentenceOne.layer.borderColor = greenColor
        sentenceTwo.layer.borderColor = greenColor
        sentenceThree.layer.borderColor = greenColor
        
        successfulClaims = 0
        
    }
    
}
