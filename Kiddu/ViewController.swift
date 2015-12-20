//
//  ViewController.swift
//  Kiddu
//
//  Created by Alvin Varghese on 16/10/15.
//  Copyright © 2015 Chamatha Lab. All rights reserved.


import UIKit
import Parse

//MARK: UIImagePickerControllerDelegate

extension ViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let mainImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                self.userThumbImage.image = mainImage.thumbnailImage(CGSizeMake(50, 50))
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: UIGestureRecognizerDelegate

extension ViewController : UIGestureRecognizerDelegate {
    
    
}

//MARK: UIGestureRecognizerDelegate

extension ViewController : UINavigationControllerDelegate {
    
    
}


//MARK: UITextFieldDelegate +

extension ViewController : UITextFieldDelegate {
    
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

class ViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var letsGetStartedLabel: UILabel!
    @IBOutlet weak var alredyHaveAnAccountButton: UIButton!
    @IBOutlet weak var Button_Sign_Up: UIButton!
    @IBOutlet weak var TextField_Name: UITextField!
    @IBOutlet weak var TextField_PIN: UITextField!
    @IBOutlet weak var TextField_Email: UITextField!
    @IBOutlet weak var userThumbImage: UIImageView!
    
    @IBOutlet weak var thirdProgressView: UIProgressView!
    @IBOutlet weak var secondProgressView: UIProgressView!
    @IBOutlet weak var firstProgressView: UIProgressView!
    
    
    //MARK: Local Variables
    
    let utilitiesObject : Utilities = Utilities()
    let parseSignUpHelperObject : ParseSignUpHelper = ParseSignUpHelper()
    let parseQueryHelperObject : ParseQueryHelper = ParseQueryHelper()
    
    var flag_AlreadyhaveAnAccount : Bool = false
    
    //MARK: View Will Appear
    
    override func viewWillAppear(animated: Bool) {
        
        if let _ = PFUser.currentUser() {
            
            self.showRecommendedUsers()
        }
    }
    
    //MARK:  View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User Image
        
        self.userThumbImage.layer.borderColor = UIColor.darkTextColor().CGColor
        self.userThumbImage.layer.borderWidth = 2
        self.userThumbImage.clipsToBounds = true
        self.userThumbImage.layer.cornerRadius = self.userThumbImage.frame.size.width / 2
        
        // Button_Sign_Up
        
        self.Button_Sign_Up.layer.borderColor = UIColor.darkTextColor().CGColor
        self.Button_Sign_Up.layer.borderWidth = 4
    
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tappedInMainView:")))
        
        // User Image Gesture
        
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("pickUserImageFromCameraRoll"))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        self.userThumbImage.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Status Bar Section
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func tappedInMainView(gesture : UITapGestureRecognizer)
    {
     self.view.endEditing(true)
    }
    
    // User Image Gesture
    
    func pickUserImageFromCameraRoll()
    {
        let imagePickerController : UIImagePickerController =  UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Sign Up Clicked
    
    @IBAction func Button_Sign_Up_Clicked(sender: UIButton)
    {
        if self.flag_AlreadyhaveAnAccount
        {
            // Log In
            
            if let username = self.TextField_Email.text, password = self.TextField_PIN.text
            {
                PFUser.logInWithUsernameInBackground(username, password: password) { user, error in
                    
                    if let _ = user
                    {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.showRecommendedUsers()
                        })
                    }
                    else
                    {
                        if let code = error?.code
                        {
                            self.handleTheErroCode(code)
                        }
                    }
                }
            }
            else
            {
                self.showNotificationWithMessage(USER_SIGNUP_AlertMessages.NO_VALID_DATA_LOGIN.rawValue)
            }
        }
        else
        {
            // Sign Up
            
            if let _ = self.TextField_Email.text, _ = self.TextField_PIN.text, _  = self.TextField_Name.text
            {
                self.signUp()
            }
            else
            {
                self.showNotificationWithMessage(USER_SIGNUP_AlertMessages.NO_VALID_DATA_SIGNUP.rawValue)
            }
        }
    }
    
    //MARK: Sign Up
    
    func signUp()
    {
        if let uuid : String = (UIDevice.currentDevice().identifierForVendor?.UUIDString), imageData : NSData = UIImagePNGRepresentation(self.userThumbImage.image!) as NSData? {
            
            self.parseSignUpHelperObject.signUpWithParameters(self.TextField_Name.text!, email: self.TextField_Email.text!, password: self.TextField_PIN.text!,uuid : uuid ,imageData : imageData,completion: { success, errorCode in
                
                if success
                {
                    self.showNotificationWithMessage(USER_SIGNUP_AlertMessages.WELCOME.rawValue)
                    
                    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("showRecommendedUsers"), userInfo: nil, repeats: false)
                }
                else
                {
                    self.handleTheErroCode(errorCode)
                }
            })
        }
        else
        {
            self.showNotificationWithMessage(USER_SIGNUP_AlertMessages.NO_UUID.rawValue)
        }
    }
    
    //MARK: Handle Error Codes
    
    func handleTheErroCode(errorCode : Int)
    {
        switch errorCode {
        case 202 : self.showNotificationWithMessage(USER_SIGNUP_AlertMessages.USER_NAME_TAKEN.rawValue)
        case 203 : self.showNotificationWithMessage(USER_SIGNUP_AlertMessages.EMAIL_TAKEN.rawValue)
        case 208 : self.showNotificationWithMessage(USER_SIGNUP_AlertMessages.ACCOUNT_ALREADY_LINKED.rawValue)
        default : ()
        }
        
    }
    
    // Remove Notificaitons from main View
    
    func removeNotificationViewFromParentView(timer : NSTimer)
    {
        if let userInfo = timer.userInfo, notification = userInfo as? NotificationShower
        {
            UIView.animateWithDuration(0.66, animations: {
                
                notification.frame = CGRectMake(0, -200, notification.frame.size.width, notification.frame.size.width)
                
                }, completion: { success in
                    
                    notification.removeFromSuperview()
            })
        }
    }
    
    func showNotificationWithMessage(text : String)
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            let notification = NotificationShower(frame: CGRectMake(0, -200, 100, 100))
            notification.updateNotificationText(text)
            self.utilitiesObject.showNotificationView(notification, parentView: self.view)
            NSTimer.scheduledTimerWithTimeInterval(1.55, target: self, selector: Selector("removeNotificationViewFromParentView:"), userInfo: notification, repeats: false)
        })
    }
    
    // Go to Home Page
    
    func showRecommendedUsers()
    {
//        NSUserDefaults.standardUserDefaults().synchronize()
//        
//        if let flag = NSUserDefaults.standardUserDefaults().boolForKey("UserFirstSignUpInApp") as Bool?
//        {
//            if flag
//            {
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                    let answerVC : HomeViewController = self.utilitiesObject.getViewController("HomeView", mainStoryBoardName: "Main") as! HomeViewController
//                    self.presentViewController(answerVC, animated: true, completion: nil)
//                })
//            }
//            else
//            {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let answerVC : RecomViewController = self.utilitiesObject.getViewController("RecommendVC", mainStoryBoardName: "Main") as! RecomViewController
                    self.presentViewController(answerVC, animated: true, completion: nil)
                })
                
              //  NSUserDefaults.standardUserDefaults().setBool(true, forKey: "UserFirstSignUpInApp")
               // NSUserDefaults.standardUserDefaults().synchronize()
           // }
       // }
    }
    
    //MARK: Login
    
    @IBAction func alreadyHaveAnAccountClicked(sender: UIButton)
    {
        if self.flag_AlreadyhaveAnAccount
        {
            // Sign Up
            
            self.firstProgressView.hidden = false
            self.TextField_Name.hidden = false
            
            self.letsGetStartedLabel.text = "Let's get started"
            self.alredyHaveAnAccountButton.setTitle("Already have an account ?", forState: UIControlState.Normal)
            
            self.flag_AlreadyhaveAnAccount = false
            
            self.Button_Sign_Up.setTitle("Sign Up", forState: UIControlState.Normal)
            
            
        }
        else
        {
            // Login
            
            self.firstProgressView.hidden = true
            self.TextField_Name.hidden = true
            
            self.letsGetStartedLabel.text = "Welcome back :)"
            
            self.alredyHaveAnAccountButton.setTitle("Dont have an account yet :( ??", forState: UIControlState.Normal)
            self.flag_AlreadyhaveAnAccount = true
            
            self.Button_Sign_Up.setTitle("Log In", forState: UIControlState.Normal)
            
        }
    }
}
