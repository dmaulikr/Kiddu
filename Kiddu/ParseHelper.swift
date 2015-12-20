//
//  ParseHelper.swift
//  Kiddu
//
//  Created by Jaison Fernando on 17/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import Foundation
import Parse
import Bolts

class ParseHelper {
    
    //MARK: Initialize Parse
    
    func initializeParse(launchOptions : [NSObject: AnyObject]?)
    {
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        
        Parse.setApplicationId("DtXjkqiGfz8SG9fjM3b03IPqVFTpVQZf8syaTYXe",
            clientKey: "mguTESY7u7c1iPHYe4SKPhzrMl1aIRzOfww28jvy")
        
        // Track statistics around application opens.
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
//        Bundle Identifier : com.ChamathaLabs.Kiddu
//        Application Key : DtXjkqiGfz8SG9fjM3b03IPqVFTpVQZf8syaTYXe
//        Client Key : mguTESY7u7c1iPHYe4SKPhzrMl1aIRzOfww28jvy
    }
    
    func refreshTheUser()
    {
        // Fetch the current user
        
        do {
            
            try PFUser.currentUser()?.fetch()
        }
        catch {
            
        }
    }
    
    func currentUserDetails(completion : (user : PFUser, objectId : String, name : String, userName : String, email : String) -> ())
    {
        if let user = PFUser.currentUser(), objectId = user["uuid"] as? String, name = user.username, userName = user["username"] as? String, email = user.email {
            
            completion(user: user, objectId: objectId, name: name, userName: userName, email : email)
        }
    }
}














