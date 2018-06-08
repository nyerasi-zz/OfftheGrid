//
//  Post.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 5/1/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class Post {
    let place: String
    let description: String
    let poster: String
    let count: Int
    let date: Date
    
    //store post location as a GMSMarker
    let location: GMSMarker

    /// The ID of the post, generated automatically on Firebase
    let postId: String
    
    /// Designated initializer for posts
    init(id: String, username: String, description: String, dateString: String, locName: String, num: Int, loc: GMSMarker) {
        self.poster = username
        self.description = description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        self.date = dateFormatter.date(from: dateString)!
        self.place = locName
        self.postId = id
        self.count = num
        self.location = loc
    }
    
    //check if post is expired
    func isActive() -> Bool {
        if (date.timeIntervalSinceNow) < 0 {
            return false
        }
        return true
    }
    
    func getTimeRemaining() -> String {
        let secondsSincePosted = date.timeIntervalSinceNow
        let minutes = Int(secondsSincePosted / 60)
        let seconds = Int(secondsSincePosted) % 60
        if minutes == 0 {
            return "Only \(seconds) remaining"
        } else if minutes == 1 {
            return "\(minutes) minute remaining"
        } else if minutes < 60 {
            return "\(minutes) minutes remaining"
        } else if minutes < 120 {
            return "1 hour remaining"
        } else if minutes < 24 * 60 {
            return "\(minutes / 60) hours remaining"
        } else if minutes < 48 * 60 {
            return "1 day remaining"
        } else {
            return "\(minutes / 1440) days remaining"
        }
        
    }
}
