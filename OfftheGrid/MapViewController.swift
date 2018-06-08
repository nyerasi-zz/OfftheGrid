//
//  MapViewController.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 5/1/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, GMSMapViewDelegate {
    //credit to Freepik from flaticon.com
    let excl = UIImage(named: "Exclamation")
    let excl2 = UIImage(named: "ReadPost")
    var manager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 10
    let currentUser = CurrentUser()
    var markers = [GMSMarker]()
    
    //goal is to read in all posts from a user's area and display the markers on the map; appearance changes for posts already seen by the user (marker color/image)
    
    var posts = [Post]()
    var activePosts = [Post]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // You don't need to modify the default init(nibName:bundle:) method.
    
    //create instance of custom info window class
    private var infoWindow = PostWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    
    func updateData() {
        getPosts(user: currentUser) { (posts) in
            if let posts = posts {
                for post in posts {
                    //check if post is expired
                    if (post.isActive()) {
                    post.location.title = "Join " + post.poster + " @ " + post.place + "!"
                    post.location.icon = self.imageWithImage(image: self.excl!, scaledToSize: CGSize(width: 25, height: 25))
                    //post.location.icon = GMSMarker.markerImage(with: UIColor.blue)
                    post.location.snippet = "\(post.count) needed with \(post.getTimeRemaining())!"
                    post.location.opacity = 0.8
                    post.location.map = self.mapView
                   //display modal popup with post description and accept button in long press of info window
                        self.activePosts.append(post)
                        self.markers.append(post.location)
                    }
                }
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // Update the data from Firebase
        updateData()
        
    }

    // MARK: GMSMapViewDelegate
    
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf
        //add functionality so long press accepts the post
        
        marker: GMSMarker) {
        print("info window pressed!")
        
        let alertController = UIAlertController(title: "Happy Questing!", message: "Post has been added to your questlog.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        marker.icon = self.imageWithImage(image: self.excl2!, scaledToSize: CGSize(width: 25, height: 25))
        marker.opacity = 0.8
        //create table view cell for questlog
        let index = markers.index(of: marker)
        let selectedPost = activePosts[index!]
        
    }
    
 
    //custom infowindow—needs renovation
    /*
    internal func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        //replaces default info window with postwindowview
        //long press means accept
        var window = Bundle.main.loadNibNamed("PostWindowView", owner: self, options: nil)
        let infoWindow = window![0] as! PostWindow
        let index = markers.index(of: marker)
        let selectedPost = activePosts[index!]
            infoWindow.poster.text = selectedPost.poster
            infoWindow.loc.text = selectedPost.place
            infoWindow.desc.text = selectedPost.description
            infoWindow.count.text = "\(0)"
            infoWindow.total.text = "\(selectedPost.count)"
        
        return infoWindow
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self //important!!
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation() //type of update
        manager.distanceFilter = 50
        manager.delegate = self
        placesClient = GMSPlacesClient.shared()
        //set arbitrary default location coords
        //cdmhs: 33.635536, -117.877422
        let camera = GMSCameraPosition.camera(withLatitude: 33.635536, longitude: -117.877422, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        //how to get current location?
        if let currentLocation = mapView.myLocation {
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
        } else {
            //campanile
            currentLocation = CLLocation(latitude: 37.872038, longitude: -122.257760)
        }
        // add the current location to appdelegate
        AppDelegate.shared().currentLocation = currentLocation!.coordinate
        view.addSubview(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //credit to MrMins from StackOverflow
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
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

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
            //list likely places method from GMS demo
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
/*
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            print("location:: (location)")
        }
        
    }
}
*/

