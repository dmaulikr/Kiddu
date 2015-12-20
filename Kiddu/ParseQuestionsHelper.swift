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
    
    //MARK: Local Variables
    
    let parseQueryHelperObject : ParseQueryHelper = ParseQueryHelper()
    
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
    
  
    
    //MARK: Update total Upvotes
    
    func updatTotalUpvote(plus : Bool, questionCurrentObjectID : String, completion : (success : Bool) -> ())
    {
        let query : PFQuery = PFQuery(className: QUESTIONS.className.rawValue)
        
        query.whereKey("objectId", equalTo: questionCurrentObjectID)
        query.findObjectsInBackgroundWithBlock { objects, error in
            
            if error != nil
            {
                // Nothing
            }
            else
            {
                if let properObjects = objects
                {
                    if properObjects.count == 0
                    {
                        // Do Nothing
                    }
                    else
                    {
                        if let input = properObjects.first
                        {
                            if let upVote = input.objectForKey(QUESTIONS.likes.rawValue) as? Int
                            {
                                if plus
                                {
                                    input[QUESTIONS.likes.rawValue] = upVote + 1
                                }
                                else
                                {
                                    input[QUESTIONS.likes.rawValue] = upVote - 1
                                }
                                
                                input.saveEventually({ success, error in
                                    
                                    completion(success: success)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //MARK: Recommended Users
    
    func getUpdatedQuestionsForTheUser( currentUserObjectId : String, completion : (success : Bool, objects : [HomeCollectionViewDatSource]) -> ())
    {
        if let query : PFQuery = PFQuery(className: QUESTIONS.className.rawValue)
        {
            self.getAllFollowers( currentUserObjectId) { allFollowers in
                
                query.whereKey(QUESTIONS.userObjectID.rawValue, containedIn: allFollowers)
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
    }
    
    func getAllValuesFrom(objects : [PFObject], completion : (objects : [HomeCollectionViewDatSource]) -> ())
    {
        var allObjects : [HomeCollectionViewDatSource] = []
        
        for index in 0..<objects.count
        {
            var data : HomeCollectionViewDatSource = HomeCollectionViewDatSource()
            
            let input = objects[index]
            
            if let userName = input.objectForKey("userName") as? String, user_question = input.objectForKey(QUESTIONS.question.rawValue) as? String, user_Kid_Name = input.objectForKey(QUESTIONS.userChildName.rawValue) as? String, _ = input.objectForKey(QUESTIONS.likes.rawValue) as? Int, _ = input.objectForKey(QUESTIONS.totalAnswers.rawValue) as? Int, mainUser = input.objectForKey(QUESTIONS.mainUser.rawValue) as? PFUser, objectid = input.objectId, imageFromServer = mainUser.objectForKey("userThumbImage") as? PFFile
            {
                data.user_Name = userName
                data.user_Kid_Name = user_Kid_Name
                data.user_question = user_question
                data.questionID = objectid

                self.getAllCommentsNumber(objectid, completion: { count in
                    
                    data.number_of_comments = count
                })
                
                data.user = mainUser
                data.objectId = objectid
                
                do {
                    let dataFromServer = try imageFromServer.getData()
                    
                    if let image = UIImage(data: dataFromServer)
                    {
                        data.thumbImage = image
                    }
                }
                catch {
                }
            }
            
            allObjects.append(data)
            
            if index == objects.count - 1
            {
                completion(objects : allObjects)
            }
        }
    }
    
    //MARK: Get All Follower's ObjectId's
    
    func getAllFollowers(objectId : String, completion : ( allFollowers : [String]) -> ())
    {
        var allFollowers : [String] = [objectId]
        
        self.parseQueryHelperObject.getUpdatedQuestionsForTheUser { success, objects in
            
            if success
            {
                for object in objects
                {
                    allFollowers.append(object.userObjectID)
                }
                
                completion(allFollowers: allFollowers)
            }
            else
            {
                completion(allFollowers: allFollowers)
            }
        }
    }
    
    
    func getAllCommentsNumber( currentQuestionId : String, completion : (count : Int) -> ())
    {
        if let query : PFQuery = PFQuery(className: ANSWERS.className.rawValue)
        {
                query.whereKey(ANSWERS.questionID.rawValue, equalTo: currentQuestionId)
                query.findObjectsInBackgroundWithBlock { objects, error in
                    
                    if error != nil
                    {
                        completion(count: 0)
                    }
                    else
                    {
                        if let properObjects = objects
                        {
                            completion(count: properObjects.count)
                        }
                        else
                        {
                            completion(count: 0)
                        }
                    }
            }
        }
    }
}



