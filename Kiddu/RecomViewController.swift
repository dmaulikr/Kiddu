//
//  RecomViewController.swift
//  Kiddu
//
//  Created by Alvin Varghese on 29/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts


extension RecomViewController : UserSignOutClickedProtocol
{
    func userLoggingoutClicked() {
        
        print("comes here ??")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


extension RecomViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        
        return self.tableViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        
        let cell : RecommendedTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("RecommendedCell", forIndexPath: indexPath) as! RecommendedTableViewCell
        
        // Follow Button
        
        cell.followButton.layer.borderColor = UIColor(red: (111 / 255 ), green: ( 113 / 255 ), blue: ( 121 / 255), alpha: 1.0).CGColor
        cell.followButton.layer.borderWidth = 2
        cell.followButton.clipsToBounds = true
        cell.followButton.titleLabel?.textAlignment = NSTextAlignment.Center
        cell.followButton.layer.cornerRadius = 2
        cell.followButton.addTarget(self, action: Selector("followButtonClicked:event:"), forControlEvents: UIControlEvents.TouchUpInside)
        cell.followButton.userInteractionEnabled = true
        
        if cell.followButton.tag == 99
        {
            cell.followButton.backgroundColor = UIColor(red: (35 / 255 ), green: ( 189 / 255 ), blue: ( 121 / 255), alpha: 1.0)
            cell.followButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        else
        {
            cell.followButton.backgroundColor = UIColor.clearColor()
            cell.followButton.setTitleColor(UIColor(red: (35 / 255 ), green: ( 189 / 255 ), blue: ( 121 / 255), alpha: 1.0), forState: UIControlState.Normal)
        }
        
        // Thumbnail Image
        
        cell.separatorInset = UIEdgeInsetsZero
        
        cell.userThumbnail.layer.borderColor = UIColor(red: (35 / 255 ), green: ( 189 / 255 ), blue: ( 121 / 255), alpha: 1.0).CGColor
        cell.userThumbnail.layer.borderWidth = 2
        cell.userThumbnail.clipsToBounds = true
        cell.userThumbnail.layer.cornerRadius = cell.userThumbnail.frame.size.width / 2
        
        cell.followers.text = "\(self.tableViewDataSource[indexPath.row].totalFollowers) Followers"
        cell.totalQuestions.text = "\(self.tableViewDataSource[indexPath.row].totalFollowers) Questions"
        cell.userName.text = self.tableViewDataSource[indexPath.row].user_Name
        cell.userThumbnail.image = self.tableViewDataSource[indexPath.row].thumbImage
        
        
        print("USER NAME : \(self.tableViewDataSource[indexPath.row].user_Name) || IMAGE : \(self.tableViewDataSource[indexPath.row].thumbImage)")
        
        return cell
    }
}

extension RecomViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

struct RecommendedTableViewDatSource {
    
    var user_Name : String = String()
    var userObjectID : String = String()
    var thumbImage : UIImage = UIImage()
    var totalQuestions : Int = Int()
    var totalFollowers : Int = Int()
}

class RecomViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recommendedUsersButton: UIButton!
    @IBOutlet weak var skipFollowingButton: UIButton!
    @IBOutlet weak var doneButotn : UIButton!
    
    //MARK: Local Variables
    
    let parseQueryHelperObject : ParseQueryHelper = ParseQueryHelper()
    var tableViewDataSource : [RecommendedTableViewDatSource] = []
    let parseHelperObject : ParseHelper = ParseHelper()
    let parseFollowersHelperObject : ParseFollowersHelper = ParseFollowersHelper()
    
    var currentlySelectedUsers : [String] = []
    
    let utilitiesObject : Utilities = Utilities()
    let parseSignUpHelperObject : ParseSignUpHelper = ParseSignUpHelper()
    
    //MARK: Appsaholic
    
    let appsaholicSDKInstance : AppsaholicSDK = AppsaholicSDK.sharedManager() as! AppsaholicSDK

    //MARK: viewWillAppear

    override func viewWillAppear(animated: Bool) {
        
        self.parseQueryHelperObject.getUpdatedQuestionsForTheUser { success, objects in
            
            if success
            {
                self.tableViewDataSource = objects
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.recommendedUsersButton.setTitle("Follow all \(self.tableViewDataSource.count) recommended users", forState: UIControlState.Normal)
                    
                    self.tableView.separatorInset = UIEdgeInsetsZero
                    self.tableView.reloadData()
                })
            }
            else
            {
                self.tableViewDataSource = []
            }
        }
    }
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add PERK Point Here
        
        if let controller = UIApplication.sharedApplication().keyWindow?.rootViewController
        {
            self.appsaholicSDKInstance.appsaholic_rootViewController = controller
            
            self.appsaholicSDKInstance.trackEvent(KEYS.DUMMY_EVENT_KEY.rawValue, withSubID: NSUUID().UUIDString, notificationType: false, withController: self, withSuccess: { success, value, number in
                
                print("Success : \(success)")
                
            })
        }
        
//        self.skipFollowingButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
//        self.skipFollowingButton.titleLabel?.textAlignment = NSTextAlignment.Center
//        self.skipFollowingButton.setTitle("\u{f0a4}", forState: UIControlState.Normal)
//        self.skipFollowingButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        
        self.doneButotn.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.doneButotn.titleLabel?.textAlignment = NSTextAlignment.Center
        self.doneButotn.setTitle("\u{f14a}", forState: UIControlState.Normal)
        self.doneButotn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.recommendedUsersButton.layer.cornerRadius = 9
        self.recommendedUsersButton.layer.borderColor = mainColor.CGColor
        self.recommendedUsersButton.layer.borderWidth = 2
        self.recommendedUsersButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.recommendedUsersButton.setTitleColor(mainColor, forState: UIControlState.Normal)
        
        self.parseHelperObject.refreshTheUser()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: Follow All People
    
    @IBAction func followAllPeopleClicked(sender: UIButton) {
        
        var allUsers : [String] = []
        
        for object in self.tableViewDataSource
        {
            let objectID = object.userObjectID

            if self.currentlySelectedUsers.contains(objectID)
            {
            }
            else
            {
                allUsers.append(objectID)
            }
        }
        
        if let user = PFUser.currentUser(), userObjectId = user.objectId
        {
            self.parseFollowersHelperObject.updateUserFollowersInBackground(userObjectId, following: allUsers)
            
            // Move to Home page
            
            self.moveToHomePage()
        }
        
    }
    
    //MARK: Skip Following
    
    @IBAction func skipFollowingButtonClicked(sender: UIButton) {
        
        // Move to Home page
        
        self.moveToHomePage()
    }
    
    //MARK: Done Following
    
    
    @IBAction func doneButtonClicked(sender: UIButton) {
        
        // Move to Home page
        
        self.moveToHomePage()
    }
    
    //MARK: Home Page ViewController
    
    func moveToHomePage()
    {
        let answerVC : HomeViewController = utilitiesObject.getViewController("HomeView", mainStoryBoardName: "Main") as! HomeViewController
        answerVC.delegate = self
        self.presentViewController(answerVC, animated: true, completion: nil)
    }
    
    //MARK: Follow a single user
    
    func followButtonClicked(sender : UIButton, event : UIEvent)
    {
        if let touch = event.touchesForView(sender)?.first, indexPath = self.tableView.indexPathForRowAtPoint(touch.locationInView(self.tableView)) {
            
            let objectID = self.tableViewDataSource[indexPath.row].userObjectID

            if let user = PFUser.currentUser(), userObjectId = user.objectId
            {
                if sender.tag == 99
                {
                    sender.setTitle("+ Follow", forState: UIControlState.Normal)
                    sender.tag = 90
                    
                    // Unselected a User
                    
                    self.currentlySelectedUsers.remove(objectID)
                }
                else
                {
                    sender.setTitle("Following", forState: UIControlState.Normal)
                    
                    self.parseFollowersHelperObject.updateUserFollowersInBackground(userObjectId, following: [objectID])
                    self.tableView.reloadData()
                    
                    sender.tag = 99
                    
                    // Selected A User
                    
                    self.currentlySelectedUsers.append(objectID)
                }
            }
        }
    }
    
    
}
