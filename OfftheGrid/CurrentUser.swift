//
//  CurrentUser.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 5/1/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class CurrentUser {
  //store read posts and preferences
    var username: String!
    var id: String!
    var readPostIDs: [String]?
    
    let dbRef = Database.database().reference()
    
    init() {
        let currentUser = Auth.auth().currentUser
        username = currentUser?.displayName
        id = currentUser?.uid
    }
    
//    func getReadPostIDs(completion: @escaping ([String]) -> Void) {
//        var postArray: [String] = []
//        self.dbRef.child(firUsersNode).child(id).child(firReadPostsNode).observeSingleEvent(of: .value) { (snapshot) in
//            let post = snapshot.value as? [String: AnyObject]
//            if let actualPost = post {
//                for (key, post) in actualPost {
//                    postArray.append(key)
//                }
//            }
//            completion(postArray)
//        }
//    }
//
//   func addNewReadPost(postID: String) {
//        self.dbRef.child(firUsersNode).child(id).child(firReadPostsNode).childByAutoId().setValue(postID)
//}
}
