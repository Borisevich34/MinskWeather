//
//  ArcForCircleView.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 04.11.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

class ArcForCircleView: UIView {
    
    var arcWidth : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        
        arcWidth = bounds.height / 20
        UIColor.lightGray.setStroke()
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = bounds.height / 2
        
        let startAngle: CGFloat = CGFloat(0)
        let endAngle: CGFloat = CGFloat(2 * M_PI + 0.5)
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - arcWidth / 2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        path.lineWidth = arcWidth
        path.stroke()
    }
}

