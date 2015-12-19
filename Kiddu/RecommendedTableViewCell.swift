//
//  RecommendedTableViewCell.swift
//  Kiddu
//
//  Created by Alvin Varghese on 29/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit

class RecommendedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var totalQuestions: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
