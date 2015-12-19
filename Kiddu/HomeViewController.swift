//
//  HomeViewController.swift
//  Kiddu
//
//  Created by Alvin Varghese on 17/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import Parse
import Bolts


extension HomeViewController : UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.collectionViewDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : HomeCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("HomeCollectionViewCell", forIndexPath: indexPath) as! HomeCollectionViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.user_Name.text = self.collectionViewDataSource[indexPath.row].user_Name
        cell.user_Kid_Name.text = self.collectionViewDataSource[indexPath.row].user_Kid_Name
        cell.user_question.text = self.collectionViewDataSource[indexPath.row].user_question
        cell.user_question_number_of_likes.text = "\(self.collectionViewDataSource[indexPath.row].number_of_likes)"
        cell.user_question_number_of_comments.text = "\(self.collectionViewDataSource[indexPath.row].number_of_comments)"
        
        cell.user_Photo.layer.cornerRadius = cell.user_Photo.frame.size.width / 2
        
        cell.user_Photo.clipsToBounds = true
        
        cell.user_Photo.image = UIImage(named: "userImage")!
        
        cell.user_question_like_button.setTitle("\u{f08a}", forState: UIControlState.Normal)
        cell.user_questions_comments_button.setTitle("\u{f0e5}", forState: UIControlState.Normal)
        
        cell.user_question.numberOfLines = 0
        cell.user_question.sizeToFit()
        
        return cell
    }
}

extension HomeViewController : UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.showAnswerViewController(self.collectionViewDataSource[indexPath.row].questionID)
        })
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let commonWidth = UIScreen.mainScreen().bounds.width - 16
        
        let labelHeight = self.collectionViewDataSource[indexPath.row].user_question.heightWithConstrainedWidth(commonWidth, font: UIFont(name: "Raleway-Light", size: 17)!)
        
        return CGSizeMake(commonWidth, labelHeight + 141)
    }
}

//MARK: HomeCollectionViewDatSource

struct HomeCollectionViewDatSource {
    
    var user_Name : String = String()
    var user_Kid_Name : String = String()
    var user_question : String = String()
    var number_of_likes : Int = Int()
    var number_of_comments : Int = Int()
    var questionID : String = String()
    var user : PFUser = PFUser()

}

class HomeViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var askANewQuestion: UIButton!
    
    
    //MARK: Local Variables
    
    let utilitiesObject : Utilities = Utilities()
    let parseSignUpHelperObject : ParseSignUpHelper = ParseSignUpHelper()
    let parseQuestionsQuesryHelper : ParseQuestionsHelper = ParseQuestionsHelper()
    
    var collectionViewDataSource : [HomeCollectionViewDatSource] = []
    
    override func viewWillAppear(animated: Bool) {
        
        if let user = PFUser.currentUser(), objectId = user["uuid"] as? String, name = user.username, email = user.email {
            
            USER_UUID_ID = objectId
            USER_NAME = name
            USER_EMAIL = email
        self.parseQuestionsQuesryHelper.getUpdatedQuestionsForTheUser(["igpVYzl6rg","okYHrEUTGp","3SZbn7hhgR","x5Mwl763pB","CtYRzcE1w5","k5M5Ju0f2d"]) { success, objects in
                
                if success
                {
                    self.collectionViewDataSource = objects.reverse()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.collectionView.reloadData()
                    })
                }
                else
                {
                    self.collectionViewDataSource = []
                    self.collectionView.reloadData()

                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.askANewQuestion.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.askANewQuestion.titleLabel?.textAlignment = NSTextAlignment.Center
        self.askANewQuestion.setTitle("\u{f067}", forState: UIControlState.Normal)
        self.askANewQuestion.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.collectionView.layoutMargins = UIEdgeInsetsZero
    }
    
    //MARK: Status Bar Section
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func showAnswerViewController(questionID : String)  {
        
        let answerVC : AnswersViewController = utilitiesObject.getViewController("AnswerVC", mainStoryBoardName: "Main") as! AnswersViewController
        answerVC.questionID = questionID
        self.presentViewController(answerVC, animated: true, completion: nil)
    }
    
    //MARK: New Question
    
    @IBAction func askANewQuestion(sender: UIButton) {
        
        let answerVC : NewQuestionViewController = utilitiesObject.getViewController("NewQusetions", mainStoryBoardName: "Main") as! NewQuestionViewController
        
        self.presentViewController(answerVC, animated: true, completion: nil)
    }
    
}































