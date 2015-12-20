//
//  AnswersViewController.swift
//  Kiddu
//
//  Created by Alvin Varghese on 26/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit
import Parse

extension AnswersViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        
        return self.tableViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        
        let cell : AnswerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AnswerTableViewCELL", forIndexPath: indexPath) as! AnswerTableViewCell
        
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.upVoteIcon.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        cell.upVoteIcon.titleLabel?.textAlignment = NSTextAlignment.Center
        cell.upVoteIcon.addTarget(self, action: Selector("clickedOnUpVoteIcon:event:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.upVoteIcon.setTitle("\u{f087}", forState: UIControlState.Normal)
        cell.upVoteIcon.setTitleColor(UIColor.darkTextColor(), forState: UIControlState.Normal)
        
        cell.answeredBy.text = "By \(self.tableViewDataSource[indexPath.row].answer_userName)"
        cell.answerLabel.text = self.tableViewDataSource[indexPath.row].answer
        cell.totalUpVotes.text = "\(self.tableViewDataSource[indexPath.row].totalUpVote)"
        
        return cell
    }
}

extension AnswersViewController : UITableViewDelegate {
    
}

struct AnswerTableViewDatSource {
    
    var answer_userID : String = String()
    var answer_userName : String = String()
    var answer : String = String()
    var totalUpVote : Int = Int()
    var questionID : String = String()
    var answer_ObjectId : String = String()
    
}

class AnswersViewController : UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAnswers: UILabel!
    @IBOutlet weak var addAnAswer: UIButton!
    
    //MARK: Local Variables
    
    let parseAnswerHelperObject : ParseAnswersHelper = ParseAnswersHelper()
    var tableViewDataSource : [AnswerTableViewDatSource] = []
    
    var questionID : String = String()
    var question : String = String()
    
    //MARK: Appsaholic
    
    let appsaholicSDKInstance : AppsaholicSDK = AppsaholicSDK.sharedManager() as! AppsaholicSDK
    
    //MARK: viewWillAppear

    override func viewWillAppear(animated: Bool) {
        
        print("questionID : \(questionID)")
        
        self.parseAnswerHelperObject.getUpdatedQuestionsForTheQuestion(self.questionID) { success, objects in
            
            if success
            {
                self.tableViewDataSource = objects.reverse()
                print(self.tableViewDataSource)

                self.executeThisAfterFetchingAnswers()
            }
            else
            {
                self.tableViewDataSource = []
                self.executeThisAfterFetchingAnswers()
            }
        }
    }
    
    // After Fetching
    
    func executeThisAfterFetchingAnswers()
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.tableView.reloadData()
            
            if self.tableViewDataSource.count == 0
            {
                self.totalAnswers.text = "No answers :("
            }
            else if self.tableViewDataSource.count == 1
            {
                self.totalAnswers.text = "1 answer"
            }
            else
            {
                self.totalAnswers.text = "\(self.tableViewDataSource.count) answers"
            }
        })
    }
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addAnAswer.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.addAnAswer.titleLabel?.textAlignment = NSTextAlignment.Center
        self.addAnAswer.setTitle("\u{f067}", forState: UIControlState.Normal)
        self.addAnAswer.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.questionLabel.text = self.question
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    //MARK: Outlets
    
    @IBAction func AddAnAnswerClicked(sender: UIButton)
    {
        let alertController : UIAlertController = UIAlertController(title: "What you think ?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Write your answer here"
        }
        
        alertController.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: { action in
            
            if let textField = alertController.textFields?.first, text = textField.text
            {
                // Post Answer to the current list
                
                
                print("text : \(text)")
                
                print("questionID : \(self.questionID)")

                self.parseAnswerHelperObject.updateAnswersBackground(text, questionID: self.questionID, completion: { success in
                    
                    if success
                    {
                        // Re fetch the answers adn show it
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.viewWillAppear(true)
                            
                                // Add PERK Point Here
                                
                                if let controller = UIApplication.sharedApplication().keyWindow?.rootViewController
                                {
                                    self.appsaholicSDKInstance.appsaholic_rootViewController = controller
                                    
                                    self.appsaholicSDKInstance.trackEvent(KEYS.DUMMY_EVENT_KEY.rawValue, withSubID: NSUUID().UUIDString, notificationType: false, withController: self, withSuccess: { success, value, number in
                                        
                                        print("Success : \(success)")
                                        
                                    })
                                }
                        })
                    }
                })
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
            
            // Cancelled
            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Back Button
    
    @IBAction func backButtonClicked(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Cell Button method target
    
    func clickedOnUpVoteIcon(sender : UIButton, event : UIEvent)
    {
        if sender.tag == 90
        {
            if let touch = event.touchesForView(sender)?.first, indexPath = self.tableView.indexPathForRowAtPoint(touch.locationInView(self.tableView)) {
                
                let answer_Object_Id = self.tableViewDataSource[indexPath.row].answer_ObjectId
                
                self.parseAnswerHelperObject.updatTotalUpvote(true, answerCurrentObjectID : answer_Object_Id, completion: { success in
                    
                    if success
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.tableView.reloadData()
                            
                        })
                    }
                })
            }
            
            sender.tag == 99
        }
        else
        {
            if let touch = event.touchesForView(sender)?.first, indexPath = self.tableView.indexPathForRowAtPoint(touch.locationInView(self.tableView)) {
                
                let answer_Object_Id = self.tableViewDataSource[indexPath.row].answer_ObjectId
                
                self.parseAnswerHelperObject.updatTotalUpvote(false, answerCurrentObjectID : answer_Object_Id, completion: { success in
                    
                    if success
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.tableView.reloadData()
                            
                        })
                    }
                })
            }
            
            sender.tag == 90
        }
    }
}

















