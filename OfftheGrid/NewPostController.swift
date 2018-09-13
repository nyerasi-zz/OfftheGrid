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
import Lottie

class NewPostController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
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
    var placeData: GMSPlace?
    let origDesc = "Inspire your squad!"
    
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var postbutton: UIButton!
    @IBOutlet var picButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func stepper(_ sender: UIStepper) {

        if sender.value == 1 {
            numPeople.text = "1 recruit"
        } else {
            numPeople.text = "\(Int(sender.value)) recruits"
        }
        //numPeople.text = "\(sender.value)"
    }
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        loc = AppDelegate.shared().currentLocation
    }
    @IBAction func searchLocationPressed(_ sender: UIButton) {
        //segue to a new window with Google Places autocomplete functionality to return a Place
        searchButton.pulsate()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func picPressed(_ sender: UIButton) {
        print("choose equirectangular pano")
        sender.pulsate()
    }
    @IBAction func saveDescription(_ sender: UIButton) {
        textViewDidEndEditing(postDescription)
    }

    @IBAction func postPressed(_ sender: UIButton) {
        //animation
        let anv = LOTAnimationView(name: "particles")
        anv.frame = CGRect(x: postbutton.frame.midX, y: postbutton.frame.midY, width: 100, height: 100)
        view.addSubview(anv)
        anv.play()
        //animate post button to
        sender.pulsate()
        
        inProgress = false
        let dbRef = Database.database().reference()
        
        guard let desc = postDescription.text else { return }
        date = datePicker.date
        guard let num = Int(numPeople.text!) else { return }
        //arbitrary location in botanical garden for testing
        loc = CLLocationCoordinate2D(latitude: 37.873495, longitude: -122.236281)
        locName = "Choose your destination."
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
        if let place = placeData {
            locLabel.text = "🧐 \(place.name) 🧐"
        } else {
            locLabel.text = "The world is yours..."
        }
        /*
        if (inProgress == false) {
            locLabel.text = "Choose your objective."
            numPeople.text = "0 recruits"
            datePicker.date = Date()
            postDescription.text = origDesc
 
        }
        */

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == origDesc {
            textView.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postDescription.delegate = self
        // Do any additional setup after loading the view.
        
        postDescription.layer.borderWidth = 2
        postDescription.layer.cornerRadius = 5
        postDescription.layer.masksToBounds = true

        searchButton.layer.borderWidth = 2
        //searchButton.layer.backgroundColor =
        searchButton.layer.cornerRadius = searchButton.layer.frame.height / 2
        searchButton.layer.m4asksToBounds = true
        searchButton.setTitleColor(.black, for: .normal)
        
        picButton.layer.borderWidth = 2
        //searchButton.layer.backgroundColor =
        picButton.layer.cornerRadius = searchButton.layer.frame.height / 2
        picButton.layer.masksToBounds = true
        picButton.setTitleColor(.black, for: .normal)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            print("dont let it scroll hor")
            scrollView.contentOffset.x = 0
        }
    }
    
    func createView() {
        //setup constraints programatically
        let globeView = UIImageView(image: #imageLiteral(resourceName: "earthIcon"))
        let timeView = UIImageView(image: #imageLiteral(resourceName: "clockIcon"))
        let picIcon = UIImageView(image: #imageLiteral(resourceName: "picturesIcon"))
        let descIcon = UIImageView(image: #imageLiteral(resourceName: "pencilIcon"))
        let countIcon = UIImageView(image: #imageLiteral(resourceName: "megaphoneIcon"))
        var imageIcons = [globeView, timeView, countIcon, descIcon, picIcon]
        for icon in imageIcons {
            //set each picture constraint
        }
        
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
extension NewPostController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.placeData = place
        print("selected \(place.name)")
        self.locLabel.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
