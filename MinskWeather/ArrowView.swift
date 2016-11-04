//
//  ArrowView.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 27.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

class ArrowView: UIView {
    
    @IBInspectable var arrowColor: UIColor = UIColor.gray
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let context : CGContext = UIGraphicsGetCurrentContext()!
       
        context.beginPath()
        context.addEllipse(in: CGRect(x: bounds.width/2 - 15, y: 0, width: 30, height: 30))
        context.move(to: CGPoint(x: bounds.width/2, y: 38.3))
        context.addLine(to: CGPoint(x: bounds.width/2 - 13.3, y: 22.3))
        context.addLine(to: CGPoint(x: bounds.width/2 + 13.3, y: 22.3))
        context.closePath()
        
        context.setFillColor(arrowColor.cgColor)
        context.fillPath()
        
        context.beginPath()
        context.addEllipse(in: CGRect(x: bounds.width/2 - 6, y: 9, width: 12, height: 12))
        context.closePath()
        
        context.setFillColor(UIColor.lightGray.cgColor)
        context.fillPath()
    }
}
