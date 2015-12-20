//
//  Extensionss.swift
//  Kiddu
//
//  Created by Jaison Fernando on 18/10/15.
//  Copyright © 2015 Chamatha Labs. All rights reserved.
//

import Foundation
import UIKit

extension Array
{
    //MARK: Remove objects from the Array
    
    mutating func removeObjects<T : Equatable>(array : [T] ) {
        for object in array {
            for index in 0..<self.count {
                if self[index] as? T == object {
                    self.removeAtIndex(index)
                }
            }
        }
    }
    
    mutating func remove( test: (Element) -> Bool) -> Int? {
        for i in 0..<self.count {
            if test(self[i]) {
                self.removeAtIndex(i)
            }
        }
        return nil
    }
    
    mutating func remove <U: Equatable> (object: U) {
        for i in (self.count-1).stride(through: 0, by: -1) {
            if let element = self[i] as? U {
                if element == object {
                    self.removeAtIndex(i)
                }
            }
        }
    }
}

extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

extension NSAttributedString {
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
}

extension UIImage {
    
    func thumbnailImage(size : CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
