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

class MapViewController: UIViewController {
    var manager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 10
    let currentUser = CurrentUser()
    //goal is to read in all posts from a user's area and display the markers on the map—appearance changes for posts already seen by the user
    var posts = [Post]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // You don't need to modify the default init(nibName:bundle:) method.
    
//    override func loadView() {
//
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
    func updateData() {
        getPosts(user: currentUser) { (posts) in
            if let posts = posts {
                for post in posts {
                    post.location.title = "-> " + post.poster + " @ " + post.place
                    post.location.icon = GMSMarker.markerImage(with: UIColor.blue)
                    post.location.opacity = 0.7
                    post.location.map = self.mapView
                }
                
                    
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        // Update the data from Firebase
        updateData()
    }
    
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
        let camera = GMSCameraPosition.camera(withLatitude: 37.871853, longitude: -122.258423, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
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

