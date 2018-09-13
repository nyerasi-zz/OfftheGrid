//
//  UIButtonExtension.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 9/7/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import Foundation
import UIKit
//trying with extending UIView to allow for shaking labels and buttons
extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        
        layer.add(flash, forKey: nil)
    }
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPt = CGPoint(x: center.x - 5, y: center.y)
        let fromVal = NSValue(cgPoint: fromPt)
        
        let toPt = CGPoint(x: center.x + 5, y: center.y)
        let toVal = NSValue(cgPoint: toPt)
        
        shake.fromValue = fromVal
        shake.toValue = toVal
        
        layer.add(shake, forKey: nil)
    }
}
