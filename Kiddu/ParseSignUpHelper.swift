//
//  ParseSignUpHelper.swift
//  Kiddu
//
//  Created by Alvin Varghese on 17/10/15.
//  Copyright © 2015 Chamatha Lab. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class ParseSignUpHelper {
    
    //MARK: Sign up -> Create the user
    
    func signUpWithParameters(name : String, email : String, password : String,uuid : String, imageData : NSData, completion : (success : Bool, errorCode : Int) -> ()) {
        
        let newUser = PFUser()
        newUser[KIDDUUSER.name.rawValue] = name
        newUser[KIDDUUSER.uuid.rawValue] = uuid
        newUser.username = email
        newUser.password = password
        newUser.email = email
        newUser[KIDDUUSER.father.rawValue] = "Father"
        newUser[KIDDUUSER.followers.rawValue] = 0
        newUser[KIDDUUSER.following.rawValue] = 0
        newUser[KIDDUUSER.location.rawValue] = PFGeoPoint(latitude: 0, longitude: 0)
        newUser[KIDDUUSER.totalQuestions.rawValue] = 0
        newUser[KIDDUUSER.userImage.rawValue] = PFFile(data: imageData)
        
        // Settings values locally
        
        USER_UUID_ID = uuid
        USER_NAME = name
        USER_EMAIL = email
        
        newUser.signUpInBackgroundWithBlock { completed, error in
            
            if completed
            {
                completion(success: true, errorCode : 0)
            }
            else
            {
                if let properEroor = error {
                    
                    switch properEroor.code {
                    case 202 : completion(success: false, errorCode : 202)
                    case 203 : completion(success: false, errorCode : 203)
                    case 208 : completion(success: false, errorCode : 208)
                    default : ()
                    }
                }
                else
                {
                    completion(success: false, errorCode : 0)
                }
            }
        }
    }

   
}













