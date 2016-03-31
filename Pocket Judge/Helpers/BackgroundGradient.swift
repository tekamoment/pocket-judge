//
//  BackgroundGradient.swift
//  Pocket Judge
//
//  Created by Carlos Arcenas on 3/21/16.
//  Copyright © 2016 Carlos Arcenas. All rights reserved.
//

import UIKit

public extension CAGradientLayer {
    class func pocketJudgeBackgroundGradientLayer(frame: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor(hex: "f8b780").CGColor, UIColor(hex: "f69880").CGColor].reverse()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
}

public extension UIImage {
    class func image(layer: CALayer) -> UIImage {
        if (UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale))) {
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.mainScreen().scale)
        } else {
            UIGraphicsBeginImageContext(layer.frame.size)
        }
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return output
    }
}

