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
        
        if self.currentlyFollowing.contains(indexPath.row)
        {
            cell.followButton.backgroundColor = UIColor(red: (111 / 255 ), green: ( 113 / 255 ), blue: ( 121 / 255), alpha: 1.0)
            cell.followButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        else
        {
            cell.followButton.backgroundColor = UIColor.clearColor()
            cell.followButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        }
        
        // Thumbnail Image
        
        cell.separatorInset = UIEdgeInsetsZero
        
        cell.userThumbnail.layer.borderColor = UIColor.whiteColor().CGColor
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
    
    let utilitiesObject : Utilities = Utilities()
    let parseSignUpHelperObject : ParseSignUpHelper = ParseSignUpHelper()
    
    var currentlyFollowing : [Int] = []
    var flag_Already_Following : Bool = false
    
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
        
        self.skipFollowingButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.skipFollowingButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.skipFollowingButton.setTitle("\u{f18e}", forState: UIControlState.Normal)
        self.skipFollowingButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
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
            allUsers.append(objectID)
        }
        
        if let user = PFUser.currentUser()
        {
            self.parseFollowersHelperObject.updateUserFollowersInBackground(user, following: allUsers)
            
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
        self.presentViewController(answerVC, animated: true, completion: nil)
    }
    
    //MARK: Follow a single user
    
    func followButtonClicked(sender : UIButton, event : UIEvent)
    {
        if let touch = event.touchesForView(sender)?.first, indexPath = self.tableView.indexPathForRowAtPoint(touch.locationInView(self.tableView)) {
            
            if let user = PFUser.currentUser()
            {
                if self.flag_Already_Following
                {
                    sender.setTitle("+ Follow", forState: UIControlState.Normal)
                    self.flag_Already_Following = false
                }
                else
                {
                    sender.setTitle("Following", forState: UIControlState.Normal)
                    
                    let objectID = self.tableViewDataSource[indexPath.row].userObjectID
                    self.parseFollowersHelperObject.updateUserFollowersInBackground(user, following: [objectID])
                    self.currentlyFollowing.append(indexPath.row)
                    self.tableView.reloadData()
                    
                    self.flag_Already_Following = true
                }
            }
        }
    }
    
    
}
