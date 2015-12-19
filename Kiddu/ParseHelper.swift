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
    
}