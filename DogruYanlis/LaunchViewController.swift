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

struct Claim {
    
    var name: String
    var sentence: String
    var truthfulness: Bool
    
}

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LaunchViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    var data = GameData()
    
    weak var delegate: DataEnteredDelegate? = nil
    
    @IBOutlet weak var playerName: UITextField!
    
    @IBOutlet weak var sentenceOne: UITextField!
    @IBOutlet weak var truthOne: UISwitch!
    
    @IBOutlet weak var sentenceTwo: UITextField!
    @IBOutlet weak var truthTwo: UISwitch!
    
    @IBOutlet weak var sentenceThree: UITextField!
    @IBOutlet weak var truthThree: UISwitch!
    
    @IBAction func save(sender: UIButton) {
    
        if (sentenceOne.text != "") {
        delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceOne.text!, truthfulness: truthOne.on))
        }
        
        if (sentenceTwo.text != "") {
        delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceTwo.text!, truthfulness: truthTwo.on))
        }
        
        if (sentenceThree.text != "") {
        delegate?.userDidEnterInformation(Claim(name: playerName.text!, sentence: sentenceThree.text!, truthfulness: truthThree.on))
        }
        
        clear()
        
    }
    
    func clear() {
        
        playerName.text = nil
        sentenceOne.text = nil
        sentenceTwo.text = nil
        sentenceThree.text = nil
        
        truthOne.on = true
        truthTwo.on = true
        truthThree.on = true
        
    }
    
}
