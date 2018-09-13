//
//  AcceptedPostCell.swift
//  OfftheGrid
//
//  Created by Nikhil Yerasi on 6/9/18.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//

import UIKit

class AcceptedPostCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellPoster: UILabel!
    @IBOutlet weak var cellLoc: UILabel!
    @IBOutlet weak var cellTime: UILabel!
    @IBOutlet weak var cellCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
