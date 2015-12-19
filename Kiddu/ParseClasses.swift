//
//  ParseClasses.swift
//  Kiddu
//
//  Created by Jaison Fernando on 18/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

//MARK: KidduUsers Class

enum KIDDUUSER : String
{
    case className = "KIDDUUSER"
    case userObjectId = "userObjectId"
    case father = "father"
    case followers = "follwers"
    case following = "following"
    case location = "location"
    case totalQuestions = "totalQuestions"
    case name = "name"
    case uuid = "uuid"
    case userImage = "userThumbImage"

}

//MARK: KidduQuestions Class

enum QUESTIONS : String
{
    case className = "QUESTIONS"
    case userObjectID = "userObjctID"
    case userChildName = "userChildName"
    case question = "question"
    case likes = "likes" // Number
    case totalAnswers = "totalAnswers" // Number
    case userName = "userName" // Number
    case tag = "tag"
    case mainUser = "mainUser"
}

//MARK: KidduQuestions Class

enum ANSWERS : String
{
    case className = "ANSWERS"
    case questionID = "questionID"

    // Answered By
    
    case answer = "answer"
    case answer_userID = "answer_userID"
    case answer_userName = "answer_userName"
    
    // Upvote
    
    case upVote = "upVote" // Number
}



var user_Name : String = String()
var answered_UserID : String = String()
var question_ID : String = String()
var question_asked_UserID : String = String()
var totalUpVote : Int = Int()
var answer : String = String()


//MARK: KidduQuestions Class

enum RECFOLLOWERS : String
{
    case className = "RECFOLLOWERS"
    case userThumbnail = "userThumbnail"
    case userObjectID = "userObjectID"
    case name = "name"
    case totalQuestions = "totalQuestions"
    case followers = "followers"
}

//MARK: KidduQuestions Class

enum Followers : String
{
    case className = "Followers"
    case mainUser = "mainUser" // Pointer to User
    case userObjectID = "userObjectID"
    case following = "iFollow"
    case followers = "followsMe"
}





















