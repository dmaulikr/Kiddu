//
//  ParseAnswersHelper.swift
//  Kiddu
//
//  Created by Alvin Varghese on 26/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import Foundation
import Parse
import Bolts
import UIKit

class ParseAnswersHelper: NSObject {
    
    //MARK:Update Answers
    
    func updateAnswersBackground(answer : String, questionID : String, completion : (success : Bool) -> () )
    {
        if let mainUser = PFUser.currentUser(), name = mainUser.objectForKey("name") as? String
        {
            let object : PFObject = PFObject(className: ANSWERS.className.rawValue)
            object[ANSWERS.answer_userID.rawValue] = mainUser.objectId
            object[ANSWERS.answer.rawValue] = answer
            object[ANSWERS.answer_userName.rawValue] = name
            object[ANSWERS.upVote.rawValue] = 0
            object[ANSWERS.questionID.rawValue] = questionID
            
            object.saveInBackgroundWithBlock { success, error in
                completion(success : success)
            }
        }
        
    }
    
    
    //MARK: Update total Upvotes
    
    func updatTotalUpvote(plus : Bool, answerCurrentObjectID : String, completion : (success : Bool) -> ())
    {
        let query : PFQuery = PFQuery(className: ANSWERS.className.rawValue)
        
        query.whereKey(ANSWERS.questionID.rawValue, equalTo: answerCurrentObjectID)
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
                            if let upVote = input.objectForKey(ANSWERS.upVote.rawValue) as? Int
                            {
                                if plus
                                {
                                    input[ANSWERS.upVote.rawValue] = upVote + 1
                                }
                                else
                                {
                                    input[ANSWERS.upVote.rawValue] = upVote - 1
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
    
    
    //MARK: Get the Latest Questions
    
    func getUpdatedQuestionsForTheQuestion(questionID : String, completion : (success : Bool, objects : [AnswerTableViewDatSource]) -> ())
    {
        let query : PFQuery = PFQuery(className: ANSWERS.className.rawValue)
        
        query.whereKey(ANSWERS.questionID.rawValue, equalTo: questionID)
        
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
    
    func getAllValuesFrom(objects : [PFObject], completion : (objects : [AnswerTableViewDatSource]) -> ())
    {
        var allObjects : [AnswerTableViewDatSource] = []
        
        for index in 0..<objects.count
        {
            var data : AnswerTableViewDatSource = AnswerTableViewDatSource()
            
            let input = objects[index]
           
            if let questionID = input.objectForKey(ANSWERS.questionID.rawValue) as? String, answer = input.objectForKey(ANSWERS.answer.rawValue) as? String, answer_User_ID = input.objectForKey(ANSWERS.answer_userID.rawValue) as? String, answer_User_Name = input.objectForKey(ANSWERS.answer_userName.rawValue) as? String, upVote = input.objectForKey(ANSWERS.upVote.rawValue) as? Int, answer_Object_Id = input.objectId
            {
                
                print("questionID : \(questionID)")
                print("answer : \(answer)")

                data.questionID = questionID
                data.answer = answer
                data.answer_userID = answer_User_ID
                data.answer_userName = answer_User_Name
                data.totalUpVote = upVote
                data.answer_ObjectId = answer_Object_Id
                
                allObjects.append(data)
            }
            
            
            if index == objects.count - 1
            {
                completion(objects : allObjects)
            }
        }
    }
    
}
