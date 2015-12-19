//
//  HomeCollectionViewCell.swift
//  Kiddu
//
//  Created by Jaison Fernando on 18/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var user_Photo: UIImageView!
    @IBOutlet weak var user_Name: UILabel!
    
    @IBOutlet weak var user_Kid_Name: UILabel!
    
    @IBOutlet weak var user_question: UILabel!
    
    @IBOutlet weak var user_question_like_button: UIButton!
    
    @IBOutlet weak var user_question_number_of_likes: UILabel!
    
    @IBOutlet weak var user_questions_comments_button: UIButton!
    
    @IBOutlet weak var user_question_number_of_comments: UILabel!
    
}
