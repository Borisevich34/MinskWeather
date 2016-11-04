//
//  ArrowView.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 27.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

class ArrowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let context : CGContext = UIGraphicsGetCurrentContext()!
        
        context.beginPath()
        context.move(to: CGPoint(x: bounds.width/2 + 0.5, y: 0 + 0.5))
        context.addLine(to: CGPoint(x: 0 + 0.5, y: bounds.height/1.8 + 0.5))
        context.addLine(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 + 0.5))
        context.addLine(to: CGPoint(x: bounds.width + 0.5, y: bounds.height/1.8 + 0.5))

        context.closePath()
        context.setFillColor(UIColor.gray.cgColor)
        context.fillPath()
    }
}
