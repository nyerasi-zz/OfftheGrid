//
//  PostFeed.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 5/2/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//


import UIKit
import Foundation
import FirebaseDatabase
import FirebaseStorage
import GoogleMaps

/// Adds the given post to the thread associated with it
/// (the thread is set as an instance variable of the post)
///
/// - Parameter post: The post to be added to the model

//func addPost(postImage: UIImage, thread: String, username: String) {
//    // Uncomment the lines beneath this one if you've already connected Firebase:
//    let dbRef = Database.database().reference()
//    let data = UIImageJPEGRepresentation(postImage, 1.0)
//    let path = "Images/\(UUID().uuidString)"
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
//    let dateString = dateFormatter.string(from: Date())
//    let postDict: [String:AnyObject] = ["imagePath": path as AnyObject,
//                                        "username": username as AnyObject,
//                                        "thread": thread as AnyObject,
//                                        "date": dateString as AnyObject]
//    dbRef.child(firPostsNode).childByAutoId().setValue(postDict)
//    store(data: data, toPath: path)
//}

func store(data: Data?, toPath path: String) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).putData(data!, metadata: nil) { (metadata, error) in
        if let error = error {
            print(error)
        }
    }
}

func getPosts(user: CurrentUser, completion: @escaping ([Post]?) -> Void) {
    let dbRef = Database.database().reference()
    var postArray: [Post] = []
    dbRef.child("Posts").observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            if let posts = snapshot.value as? [String:AnyObject] {
                for postKey in posts.keys {
                    let postDict = posts[postKey]! as! [String:AnyObject]
                    let coord = CLLocationCoordinate2D(latitude: postDict["lat"] as! Double, longitude: postDict["lon"] as! Double)
                    let newPost = Post(id: postKey, username: postDict["poster"] as! String, description: postDict["desc"] as! String, dateString: postDict["date"] as! String, locName: postDict["place"] as! String, num: postDict["num"] as! Int, loc: GMSMarker(position: coord) )
                        postArray.append(newPost)
                    }
                    completion(postArray)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    })
}

func getDataFromPath(path: String, completion: @escaping (Data?) -> Void) {
    let storageRef = Storage.storage().reference()
    storageRef.child(path).getData(maxSize: 5 * 1024 * 1024) { (data, error) in
        if let error = error {
            print(error)
        }
        if let data = data {
            completion(data)
        } else {
            completion(nil)
        }
    }
}

