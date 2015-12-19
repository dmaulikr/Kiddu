//
//  Utilities.swift
//  Kiddu
//
//  Created by Alvin Varghese on 17/10/15.
//  Copyright © 2015 Chamatha Lab. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    func showNotificationView(view : NotificationShower, parentView : UIView) {
        
            dispatch_async(dispatch_get_main_queue(), {
                
                parentView.addSubview(view)
                
                UIView.animateWithDuration(0.99, animations: {
                    
                    view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
                    
                    }, completion: nil)
            })
    }
    
    
    // MARK: - Getting UIViewController
    
    func getViewController(storyBoard : NSString, mainStoryBoardName : String) -> UIViewController
    {
        let mystoryBoard : UIStoryboard = UIStoryboard(name: mainStoryBoardName, bundle: nil) as UIStoryboard
        let viewControllerID : UIViewController = mystoryBoard.instantiateViewControllerWithIdentifier(storyBoard as String)
        
        return viewControllerID
    }
}