//
//  PostWindow.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 6/4/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit

class PostWindow: UIView {
    
    //REDO XIB file for design overhaul
    
    @IBOutlet weak var poster: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var loc: UILabel!
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var timeLeft: UILabel!
    
    
    @IBAction func accept(_ sender: Any) {
        print("add this post to quest log!")
    }
    
    //https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960
//    override init(frame: CGRect) {
//        //for using custom view in code
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        //for using custom view in interface builder
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        Bundle.main.loadNibNamed("PostWindowView", owner: self, options: nil)
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PostWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
