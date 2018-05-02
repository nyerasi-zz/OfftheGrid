//
//  NewPostController.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 5/2/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import GoogleMaps
import GooglePlaces

class NewPostController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numPeople: UILabel!
    
    @IBOutlet weak var locLabel: UILabel!
    
    var inProgress = false;
    var desc = ""
    var locName = ""
    var poster = ""
    var date: Date?
    var num = 0
    var loc: CLLocationCoordinate2D?
    let currentUser = Auth.auth().currentUser
    var pData = PlaceData()
    let origDesc = "Enter a brief description here to recruit other users and tap Save when done!"
    
    @IBAction func stepper(_ sender: UIStepper) {
        numPeople.text = String(Int(sender.value))
    }
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        loc = AppDelegate.shared().currentLocation
    }
    @IBAction func searchLocationPressed(_ sender: UIButton) {
        //segue to a new window with Google Places autocomplete functionality to return a Place
        
    }
    
    @IBAction func saveDescription(_ sender: UIButton) {
        textViewDidEndEditing(postDescription)
    }

    @IBAction func postPressed(_ sender: UIButton) {
        inProgress = false
        let dbRef = Database.database().reference()
        
        guard let desc = postDescription.text else { return }
        date = datePicker.date
        guard let num = Int(numPeople.text!) else { return }
        //arbitrary location in botanical garden for testing
        loc = CLLocationCoordinate2D(latitude: 37.873495, longitude: -122.236281)
        locName = "Choose your destination."
        if pData.name != "" {
            loc = pData.coord
            locName = pData.name
        }
        guard let poster = currentUser!.displayName else { return }
        if desc == origDesc || desc == "" || locName == "" || num == 0 || loc == nil {
            let alertController = UIAlertController(title: "Form Error.", message: "Please fill in form completely.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            //how should we store/represent dates?
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
            let dateString = dateFormatter.string(from: date!)
            let postDict: [String:AnyObject] = ["poster": poster as AnyObject, "date": dateString as AnyObject, "num": num as AnyObject, "lat":loc!.latitude as AnyObject, "lon":loc!.longitude as AnyObject, "place":locName as AnyObject, "desc":desc as AnyObject]
            
            //store in database!
            dbRef.child("Posts").childByAutoId().setValue(postDict)
            self.navigationController?.popToRootViewController(animated: true)
            let alertController = UIAlertController(title: "Post Added!", message: "Your post has been added to the map.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        locLabel.text = pData.name
        if (inProgress == false) {
            locLabel.text = "Choose your objective."
            postDescription.text = origDesc
            numPeople.text = "0"
            datePicker.date = Date()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postDescription.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        inProgress = true
        if textView == self.postDescription {
            if textView.text != nil {
                self.desc = textView.text
            self.postDescription.resignFirstResponder()
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
