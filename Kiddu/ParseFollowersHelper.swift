//
//  ParseFollowersHelper.swift
//  Kiddu
//
//  Created by Alvin Varghese on 19/12/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class ParseFollowersHelper {
    
    //MARK: Updates user followers in background
    
    func updateUserFollowersInBackground(currentUserObjectId : String, following : [String])
    {
        for followinThesePeople in following
        {
            let object : PFObject = PFObject(className: Followers.className.rawValue)
            object[Followers.userObjectId.rawValue] = currentUserObjectId
            object[Followers.followerUserObjectId.rawValue] = followinThesePeople
            object.saveInBackground()
        }
    }
    
    //MARK: Recommended Users
    
    func getUpdatedQuestionsForTheUser(currentUserObjectId : String, completion : (success : Bool, objects : [RecommendedTableViewDatSource]) -> ())
    {
        if let query : PFQuery = PFQuery(className: Followers.className.rawValue)
        {
            query.whereKey(Followers.userObjectId.rawValue, equalTo: currentUserObjectId)
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
    
    func getAllValuesFrom(objects : [PFObject], completion : (objects : [RecommendedTableViewDatSource]) -> ())
    {
        var allObjects : [RecommendedTableViewDatSource] = []
        
        for index in 0..<objects.count
        {
            var data : RecommendedTableViewDatSource = RecommendedTableViewDatSource()
            
            let input = objects[index]
            
            if let userName = input.objectForKey("name") as? String, imageFromServer = input.objectForKey(KIDDUUSER.userImage.rawValue) as? PFFile, totalQuestions = input.objectForKey(KIDDUUSER.totalQuestions.rawValue) as? Int, followers = input.objectForKey(KIDDUUSER.followers.rawValue) as? Int, objectID = input.objectId
            {
                data.user_Name = userName
                data.totalQuestions = totalQuestions
                data.totalFollowers = followers
                data.userObjectID = objectID
                
                print("objectID : \(objectID)")
                
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
}
