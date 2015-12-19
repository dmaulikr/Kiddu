//
//  NotificationShower.swift
//  Kiddu
//
//  Created by Jaison Fernando on 17/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import UIKit

class NotificationShower: UIView {
    
    @IBOutlet weak var notificationText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let views = NSBundle.mainBundle().loadNibNamed("NotificationView", owner: self, options: nil)
        
        let view = views[0] as! UIView
        
        view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, view.frame.size.height)
        view.updateConstraints()
        
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateNotificationText(text : String)
    {
        self.notificationText.text = text
    }
    
}
