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

extension HomeViewController : LogOutUserFromHereProtocol
{
    func userLoggingOut() {
        
        self.delegate.userLoggingoutClicked()
        self.dismissViewControllerAnimated(true , completion: nil)
    }
}

extension HomeViewController : NewQuestionAskedProtocol
{
    func newQuestionSuccessfullyAsked() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            // Add PERK Point Here
            
            if let controller = UIApplication.sharedApplication().keyWindow?.rootViewController
            {
                self.appsaholicSDKInstance.appsaholic_rootViewController = controller
                
                self.appsaholicSDKInstance.trackEvent(KEYS.DUMMY_EVENT_KEY.rawValue, withSubID: NSUUID().UUIDString, notificationType: false, withController: self, withSuccess: { success, value, number in
                    
                    print("Success : \(success)")
                    
                })
            }
        }
    }
}

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
        
        cell.user_Photo.image = self.collectionViewDataSource[indexPath.row].thumbImage
        
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
            
            self.showAnswerViewController(self.collectionViewDataSource[indexPath.row].questionID, question : self.collectionViewDataSource[indexPath.row].user_question)
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
    
    var objectId : String = String()
    var user_Name : String = String()
    var user_Kid_Name : String = String()
    var user_question : String = String()
    var number_of_likes : Int = Int()
    var number_of_comments : Int = Int()
    var questionID : String = String()
    var user : PFUser = PFUser()
    var thumbImage : UIImage = UIImage()
}

protocol UserSignOutClickedProtocol
{
    func userLoggingoutClicked()
}

class HomeViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var askANewQuestion: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    //MARK: Local Variables
    
    let utilitiesObject : Utilities = Utilities()
    let parseSignUpHelperObject : ParseSignUpHelper = ParseSignUpHelper()
    let parseQuestionsQuesryHelper : ParseQuestionsHelper = ParseQuestionsHelper()
    
    var delegate : UserSignOutClickedProtocol!
    var collectionViewDataSource : [HomeCollectionViewDatSource] = []
    
    //MARK: Appsaholic
    
    let appsaholicSDKInstance : AppsaholicSDK = AppsaholicSDK.sharedManager() as! AppsaholicSDK
    
    
    override func viewWillAppear(animated: Bool) {
        
        if let user = PFUser.currentUser(),currentObjectId = user.objectId {
            
            self.parseQuestionsQuesryHelper.getUpdatedQuestionsForTheUser(currentObjectId) { success, objects in
                
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
        
        
       
        
        // Ask a new question
        
        self.askANewQuestion.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.askANewQuestion.titleLabel?.textAlignment = NSTextAlignment.Center
        self.askANewQuestion.setTitle("\u{f067}", forState: UIControlState.Normal)
        self.askANewQuestion.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        // Settings Button
        
        self.settingsButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.settingsButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.settingsButton.setTitle("\u{f013}", forState: UIControlState.Normal)
        self.settingsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.collectionView.layoutMargins = UIEdgeInsetsZero
    }
    
    //MARK: Status Bar Section
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func showAnswerViewController(questionID : String, question : String)  {
        
        let answerVC : AnswersViewController = utilitiesObject.getViewController("AnswerVC", mainStoryBoardName: "Main") as! AnswersViewController
        answerVC.questionID = questionID
        answerVC.question = question
        self.presentViewController(answerVC, animated: true, completion: nil)
    }
    
    //MARK: New Question
    
    @IBAction func askANewQuestion(sender: UIButton) {
        
        let answerVC : NewQuestionViewController = utilitiesObject.getViewController("NewQusetions", mainStoryBoardName: "Main") as! NewQuestionViewController
        answerVC.delegate = self
        self.presentViewController(answerVC, animated: true, completion: nil)
    }
    
    //MARK: Settings Button Clicked
    
    @IBAction func settingsButtonClicked(sender: UIButton) {
        
        let settingsVC : SettingsPageViewController = utilitiesObject.getViewController("SettingsPage", mainStoryBoardName: "Main") as! SettingsPageViewController
        settingsVC.delegate = self
        self.presentViewController(settingsVC, animated: true, completion: nil)
    }
    
    
    func clickedOnUpVoteIcon(sender : UIButton, event : UIEvent)
    {
        if sender.tag == 90
        {
            if let touch = event.touchesForView(sender)?.first, indexPath = self.collectionView.indexPathForItemAtPoint(touch.locationInView(self.collectionView)) {
                
                let answer_Object_Id = self.collectionViewDataSource[indexPath.row].objectId
                
                self.parseQuestionsQuesryHelper.updatTotalUpvote(true, questionCurrentObjectID : answer_Object_Id, completion: { success in
                    
                    if success
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.collectionView.reloadData()
                            
                        })
                    }
                })
            }
            
            sender.tag == 99
        }
        else
        {
            if let touch = event.touchesForView(sender)?.first, indexPath = self.collectionView.indexPathForItemAtPoint(touch.locationInView(self.collectionView)) {
                
                let answer_Object_Id = self.collectionViewDataSource[indexPath.row].objectId
                
                self.parseQuestionsQuesryHelper.updatTotalUpvote(false, questionCurrentObjectID : answer_Object_Id, completion: { success in
                    
                    if success
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.collectionView.reloadData()
                            
                        })
                    }
                })
            }
            
            sender.tag == 90
        }
    }

}































