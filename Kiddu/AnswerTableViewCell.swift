//
//  AnswerTableViewCell.swift
//  Kiddu
//
//  Created by Alvin Varghese on 26/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var answeredBy: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var upVoteIcon: UIButton!
    @IBOutlet weak var totalUpVotes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
