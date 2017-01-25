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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
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
    

    @IBAction func newGame(sender: UIButton) {
        
        ref.child("sessions").observeSingleEventOfType(.Value, withBlock: {
            (snapshot) in
            
            if snapshot.hasChild(self.gameName){
                
                print("Game already exists. We are directing you to the game!")
                
            } else {
                print(self.gameName)
                self.ref.child("sessions/\(self.gameName)/users/name").setValue(self.userNameField.text!.lowercaseString)
                
            }
        })

    }
    
    @IBAction func joinGame(sender: UIButton) {
        self.ref.child("sessions/\(gameNameField.text!)/users/")
    }
    
    func joinGameWithName(gameName: String) {
        
        
    }

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
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
