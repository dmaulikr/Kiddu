//
//  NotificationMessages.swift
//  Kiddu
//
//  Created by Jaison Fernando on 17/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import Foundation

enum USER_SIGNUP_AlertMessages : String
{
    // PFUSER SIGN UP
    
    case USER_NAME_TAKEN = "Username already taken."
    case EMAIL_TAKEN = "User email already taken"
    case ACCOUNT_ALREADY_LINKED = "This account is already linked. Please check your details"
    case WELCOME = "Welcome to Kiddu"
    case NO_UUID = "Could not get the device vendor details"
    case NO_VALID_DATA_SIGNUP = "Please enter the name, username and password properly"
    case NO_VALID_DATA_LOGIN = "Please enter the username and password properly"

}
