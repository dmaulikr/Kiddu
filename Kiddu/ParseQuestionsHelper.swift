//
//  ParseQuestionsHelper.swift
//  Kiddu
//
//  Created by Alvin Varghese on 28/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class ParseQuestionsHelper: NSObject {

    func updateUserDetailsInBackground(mainUser : PFUser, userObjectId : String, childName : String, question : String, userName : String, tag : String, completion : (success : Bool) -> () )
    {
        let object : PFObject = PFObject(className: QUESTIONS.className.rawValue)
        object[QUESTIONS.userObjectID.rawValue] = userObjectId
        object[QUESTIONS.userChildName.rawValue] = childName
        object[QUESTIONS.question.rawValue] = question
        object[QUESTIONS.likes.rawValue] = 0
        object[QUESTIONS.totalAnswers.rawValue] = 0
        object[QUESTIONS.userName.rawValue] = userName
        object[QUESTIONS.mainUser.rawValue] = mainUser
        object[QUESTIONS.tag.rawValue] = tag
        object.saveInBackgroundWithBlock { success, error in
            completion(success : success)
        }
    }

    //MARK: Recommended Users
    
    func getUpdatedQuestionsForTheUser(array : [String], completion : (success : Bool, objects : [HomeCollectionViewDatSource]) -> ())
    {
        if let query : PFQuery = PFQuery(className: QUESTIONS.className.rawValue)
        {
            query.whereKey(QUESTIONS.userObjectID.rawValue, containedIn: array)
            query.findObjectsInBackgroundWithBlock { objects, error in
                
                if error != nil
                {
                    completion(success: false, objects : [])
                }
                else
                {
                    if let properObjects = objects
                    {
                        if properObjects.count == 0
                        {
                            completion(success: false, objects : [])
                        }
                        else
                        {                            
                            self.getAllValuesFrom(properObjects, completion: { values in
                                
                                print(properObjects)
                                completion(success: true, objects : values)
                            })
                        }
                    }
                    else
                    {
                        completion(success: false, objects : [])
                    }
                }
            }
        }
    }
    
    func getAllValuesFrom(objects : [PFObject], completion : (objects : [HomeCollectionViewDatSource]) -> ())
    {
        var allObjects : [HomeCollectionViewDatSource] = []
        
        for index in 0..<objects.count
        {
            var data : HomeCollectionViewDatSource = HomeCollectionViewDatSource()
            
            let input = objects[index]
            
            if let userName = input.objectForKey("userName") as? String, user_question = input.objectForKey(QUESTIONS.question.rawValue) as? String, user_Kid_Name = input.objectForKey(QUESTIONS.userChildName.rawValue) as? String, likes = input.objectForKey(QUESTIONS.likes.rawValue) as? Int, totalAnswers = input.objectForKey(QUESTIONS.totalAnswers.rawValue) as? Int, mainUser = input.objectForKey(QUESTIONS.mainUser.rawValue) as? PFUser
            {
                data.user_Name = userName
                data.user_Kid_Name = user_Kid_Name
                data.user_question = user_question
                data.number_of_likes = likes
                data.number_of_comments = totalAnswers
                data.user = mainUser
            }
            
            allObjects.append(data)
            
            if index == objects.count - 1
            {
                completion(objects : allObjects)
            }
        }
    }

}
