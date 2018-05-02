//
//  LoginViewController.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 4/22/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var userName = ""
    var passWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        username.textColor = UIColor.purple
        password.textColor = UIColor.purple
        guard let usernameText = username.text else { return }
        guard let passwordText = password.text else { return }
        
        if usernameText == "" || passwordText == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields
            let alertController = UIAlertController(title: "Log In Error", message: "Please enter a username and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            //using default email address advntr.live
            // api doc https://firebase.google.com/docs/auth/ios/start
            let email = usernameText + "@advntr.live"
            Auth.auth().signIn(withEmail: email, password: passwordText) { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "LoginToMain", sender: self)
                }
                else {
                    let alertController = UIAlertController(title: "Log In Error", message:
                        error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    //used to prevent user from having to log in at start
    //comment out for debugging
   // /*
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener() { (auth, user) in
            if user != nil {
                //self.performSegue(withIdentifier: "LoginToMain", sender: self)
            }
        }
    }
   // */
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.username {
            if textField.text != nil {
                self.userName = textField.text!
            }
        } else {
            if textField.text != nil {
                self.passWord = textField.text!
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
