//
//  SignInViewController.swift
//  DogruYanlis
//
//  Created by Başar Oğuz on 25/01/17.
//  Copyright © 2017 basaroguz. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {

    var ref: FIRDatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        self.gameNameField.delegate = self
        self.userNameField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        gameNameField.text = nil
        userNameField.text = nil
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignInViewController.keyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignInViewController.keyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBOutlet weak var gameNameField: UITextField!
    
    private var gameName: String {
        get {
            if (gameNameField.text != nil) {
                return (gameNameField.text?.lowercaseString)!
            }
            else {
                return ""
            }
        }
    }
    
    @IBOutlet weak var userNameField: UITextField!
    
    private var userName: String {
        get {
            if (userNameField.text != nil) {
                return userNameField.text!
            }
            else {
                return ""
            }

        }
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        //textField.placeholder = ""
    }

    @IBAction func newGame(sender: UIButton) {
        
        if gameExists(gameName){
                
                let gameExistsAlert = UIAlertController(title: "Game Already Exists", message: "Do you want to join the game with this name instead of creating a new game?", preferredStyle: UIAlertControllerStyle.Alert)
                
                gameExistsAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {(action: UIAlertAction!) in
                    
                    self.performSegueWithIdentifier("joinGame", sender: self)
                    
                }))
                
                gameExistsAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {(action: UIAlertAction!) in
                    
                }))
                
                self.presentViewController(gameExistsAlert, animated: true, completion: nil)
                
                print("Game already exists. We are directing you to the game!")
                
            } else {
            
                self.ref.child("sessions/\(self.gameName)/users/name").setValue(self.userNameField.text!.lowercaseString)
            
            }
    }

    
    
    @IBAction func joinGame(sender: UIButton) {
        self.ref.child("sessions/\(gameNameField.text!)/users/")
    }
    
    func gameExists(gameName: String) -> Bool {
        
        var gameExists: Bool = false
        
        ref.child("sessions").observeSingleEventOfType(.Value,
            withBlock: {
                (snapshot) in
                
                if snapshot.hasChild(self.gameName){
                    gameExists = true
                } else {
                    gameExists = false
                }
            }
        )
        
        return gameExists
    }
    
    func joinGameWithName(gameName: String) {
        
        
    }

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "startNewGame") {
            let navigationViewController = segue.destinationViewController as! UINavigationController
            let destinationViewController = navigationViewController.viewControllers[0] as! GameViewController
            
            destinationViewController.data.gameID = gameName
            destinationViewController.data.addPlayer(userName)
        }
    }
    
    
    func keyboardWillShowNotification(notification: NSNotification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            self.bottomConstraint.constant = -keyboardFrame.size.height
            self.view.layoutIfNeeded()

        })

    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
