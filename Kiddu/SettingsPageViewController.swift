//
//  SettingsPageViewController.swift
//  Kiddu
//
//  Created by Alvin Varghese on 19/12/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import Parse
import Bolts

extension SettingsPageViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        
        return self.tableViewDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        
        let cell : SettingsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("SettingsPageCell", forIndexPath: indexPath) as! SettingsTableViewCell
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero

        cell.actionLabel.text = self.tableViewDataSource[indexPath.row]
        
        return cell
    }
}

extension SettingsPageViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row
        {
            
        case 2 : self.shareWithFriends()
            
        case 4 :
            
            PFUser.logOut() // Log out user
            self.dismissViewControllerAnimated(true , completion: nil)
            self.delegate.userLoggingOut()

        default :
            
            let alertController : UIAlertController = UIAlertController(title: "Thats not available :(", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { action in
               
            }))
           
            self.presentViewController(alertController, animated: true, completion: nil)

        }
    }
}

protocol LogOutUserFromHereProtocol
{
    func userLoggingOut()
}

class SettingsPageViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Local Variables
    
    var tableViewDataSource : [String] = ["See tutorial","Faq", "Share with friends", "Rate us in App Store", "Log Out :("]
    var delegate : LogOutUserFromHereProtocol!

    //MARK: Appsaholic
    
    let appsaholicSDKInstance : AppsaholicSDK = AppsaholicSDK.sharedManager() as! AppsaholicSDK
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        // Back Button
        
        self.backButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.backButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.backButton.setTitle("\u{f0a8}", forState: UIControlState.Normal)
        self.backButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    //MARK: Back Button Clicked
    
    @IBAction func backButtonClicked(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  

    func shareWithFriends()
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            let itemsToShare : NSArray = [ "Kiddu App :)"]
            let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: itemsToShare as [AnyObject], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]
            self.presentViewController(activityViewController, animated: true, completion: {
                
                
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
                
            })
        })
    }
    
}
