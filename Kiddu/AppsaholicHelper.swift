//
//  AppsaholicHelper.swift
//  dummye
//
//  Created by Alvin Varghese on 16/12/15.
//  Copyright © 2015 I Dream Code. All rights reserved.
//

import Foundation
import UIKit

class AppsaholicHelper {
    
    //MARK: Details - Appsaholic
    
    private enum CommonDetails : String
    {
        case AdClosingNotification = "SDKAdCloseNotification"
    }
    
    //MARK: Shared Instance
    
    class var sharedInstance : AppsaholicHelper {
        
        struct Static {
            
            static var sharedInstance: AppsaholicHelper?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.sharedInstance = AppsaholicHelper()
        }
        
        return Static.sharedInstance!
    }
    
    //MARK: Local Variables
    
    let appsaholicSDKInstance : AppsaholicSDK = AppsaholicSDK()
    
    //MARK: Initialize AppsaholicSDKHelper
    
    func initializeSDK (API_KEY : String, completion : (success : Bool, message : String) -> Void!) {
        
        self.appsaholicSDKInstance.startSession(API_KEY) { success, value in
            
            completion(success: success, message: value)
        }
    }
    
    //MARK: Pointing View Controller to Appsaholic SDK
    
    func pointingThisViewController(target : UIViewController)
    {
        self.appsaholicSDKInstance.appsaholic_rootViewController = target
    }
    
    //MARK: Track Events
    
    func trackEvents(target : UIViewController, eventID : String, subID : String, notificationType : Bool, completion : (success : Bool) -> Void!)
    {
        //  Use Your Own Notification Design - By passing "notificationType" true
        
        self.appsaholicSDKInstance.trackEvent(eventID, withSubID: subID, notificationType: notificationType, withController: target) { success, value , number in
            
            completion(success: success)
        }
    }
    
    //MARK: Adding PERK Portal
    
    func showPERKPortalHere()
    {
        self.appsaholicSDKInstance.showPortal()
    }
    
    //MARK: Claim Points Custom View
    
    func claimPointsCustomView(target : UIViewController)
    {
        self.appsaholicSDKInstance.claimPoints(target)
    }
    
    //MARK: Advance Notification for Advertisement closing
    
    func addObserverForAdvertisementClosing(target : UIViewController, methodName : String)
    {
        dispatch_async(dispatch_get_main_queue()) {
        
            NSNotificationCenter.defaultCenter().addObserver(target, selector: Selector(methodName), name: CommonDetails.AdClosingNotification.rawValue, object: nil)
        }
    }
    
}








