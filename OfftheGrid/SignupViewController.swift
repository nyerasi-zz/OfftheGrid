//
//  SignupViewController.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 4/18/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var confirmPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
