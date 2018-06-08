//
//  SignupViewController.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 4/18/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var emailText = ""
    var usernameText = ""
    var passwordText = ""
    var confirmText = ""
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        guard let password = password.text else { return }
        guard let name = username.text else { return }
        guard let verifiedPassword = confirmPassword.text else { return }
        if password == "" || name == "" || verifiedPassword == "" {
            let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            let email = name + "@advntr.live"
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges { (error) in
                        let alertController = UIAlertController(title: "Welcome, " + name + "!", message: "You have successfully created your account", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (defaultAction) in
                            alertController.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: "SignupToMain", sender: self)
                        }))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    
                } else if password != verifiedPassword {
                    let alertController = UIAlertController(title: "Verification Error.", message: "The two passwords do not match.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.confirmPassword.textColor = UIColor.red
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Sign Up Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        username.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.password {
            if textField.text != nil {
                self.passwordText = textField.text!
            }
        } else if textField == self.username {
            if textField.text != nil {
                self.usernameText = textField.text!
            }
        } else if textField == self.confirmPassword {
            if textField.text != nil {
                self.confirmText = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
