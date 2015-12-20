//
//  NewQuestionViewController.swift
//  Kiddu
//
//  Created by Alvin Varghese on 29/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import Parse
import Bolts


//MARK: UITextFieldDelegate +

extension NewQuestionViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}

protocol NewQuestionAskedProtocol
{
    func newQuestionSuccessfullyAsked()
}


class NewQuestionViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitQuestionButton: UIButton!
    
    //MARK: Local Variables
    
    var delegate : NewQuestionAskedProtocol!
    let parseQuestionsQuesryHelper : ParseQuestionsHelper = ParseQuestionsHelper()
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 30)
        self.backButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.backButton.setTitle("\u{f060}", forState: UIControlState.Normal)
        self.backButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        
        self.questionTextField.layer.cornerRadius = 7
        self.questionTextField.layer.borderColor = mainColor.CGColor
        self.questionTextField.layer.borderWidth = 2
        self.questionTextField.textAlignment = NSTextAlignment.Left
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    @IBAction func backButtonOutlet(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Submit Question
    
    @IBAction func submitQuestion(sender: UIButton) {
        
        if let user = PFUser.currentUser(), objectId = user.objectId, userName = user.objectForKey("name") as? String, properText = self.questionTextField.text {
                        
            self.parseQuestionsQuesryHelper.updateUserDetailsInBackground(user, userObjectId: objectId, childName: "Child Name", question: properText, userName: userName, tag: "No Tag", completion: { success in
                
                if success
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.delegate.newQuestionSuccessfullyAsked()
                        self.submitQuestionButton.setTitle("Submitted :)", forState: UIControlState.Normal)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            })
        }
        
    }
    
    
    
}





















