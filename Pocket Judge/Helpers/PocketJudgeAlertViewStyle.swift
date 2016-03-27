//
//  PocketJudgeAlertViewStyle.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/22/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import Foundation
import SDCAlertView

public extension AlertController {
    public class func pocketJudgeAlertController(title: String, message: String) -> AlertController {
        // create attributed strings fro title and message
        let titleAttributeDictionary = [NSFontAttributeName: UIFont(name: "TeXGyreAdventor-Bold", size: 26.25)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleAttributeDictionary)
        
        let paragraphSpacingAttribute = NSMutableParagraphStyle()
        paragraphSpacingAttribute.lineSpacing = 0.0
        paragraphSpacingAttribute.maximumLineHeight = 20.0
        paragraphSpacingAttribute.alignment = .Center
        
        let spacedMessage = "\n \(message) \n"
        let messageAttributeDictionary = [NSFontAttributeName: UIFont(name: "TeXGyreAdventor-Regular", size: 20)!, NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: paragraphSpacingAttribute]
        let messageAttrString = NSMutableAttributedString(string: spacedMessage, attributes: messageAttributeDictionary)
        
        let output = AlertController(attributedTitle: titleAttrString, attributedMessage: messageAttrString)
        output.visualStyle = PocketJudgeAlertStyle(alertStyle: .Alert)
        output.addAction(AlertAction(title: "OK", style: .Default))
        
        return output
    }
}


public class PocketJudgeAlertStyle: VisualStyle {
    
    public func font(forAction action: AlertAction?) -> UIFont {
        return UIFont(name: "TeXGyreAdventor-Bold", size: 30)!
    }
    
    public var backgroundColor: UIColor? {
        return UIColor(hex: "f6b783")
    }
    
    public func textColor(forAction action: AlertAction?) -> UIColor {
        return UIColor.whiteColor()
    }
    
    // inherited from DefaultAlertStyle
    
    private let alertStyle: AlertControllerStyle
    init(alertStyle: AlertControllerStyle) { self.alertStyle = alertStyle }
    
    public var width: CGFloat { return self.alertStyle == .Alert ? 250 : 1 }
    
    public var cornerRadius: CGFloat {
            return 0

    }
    public var margins: UIEdgeInsets {
        if self.alertStyle == .Alert {
            return UIEdgeInsets(top: 30, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets(top: 30, left: 10, bottom: -10, right: 10)
        }
    }
    
    public var actionViewSize: CGSize {
            return self.alertStyle == .Alert ? CGSize(width: 90, height: 44) : CGSize(width: 90, height: 57)

    }

}