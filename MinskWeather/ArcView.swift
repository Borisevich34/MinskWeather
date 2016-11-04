//
//  CircleView.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 02.11.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

@IBDesignable
class ArcView: UIView {

    @IBInspectable var arcColor: UIColor = UIColor.gray
    
    private var arcWidth = CGFloat()
    private let ratio : CGFloat = 0.07143

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override func draw(_ rect: CGRect) {
        
        arcWidth = bounds.width * ratio
        
        arcColor.setStroke()
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = bounds.height
        
        let startAngle: CGFloat = CGFloat(3.0 * M_PI / 4.0)
        let endAngle: CGFloat = CGFloat(M_PI / 4.0)

        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        path.lineWidth = arcWidth
        path.stroke()
        
        let leftX = center.x - (radius/2) * CGFloat(sin(M_PI / 4.0))
        let leftY = center.y + (radius/2) * CGFloat(cos(M_PI / 4.0))
        let leftCenter = CGPoint(x: leftX, y : leftY)
        arcColor.setStroke()
        let leftPath = UIBezierPath(arcCenter: leftCenter,
                                    radius: 0.0715 * bounds.width / 2,
                                    startAngle: CGFloat(M_PI / 4.0),
                                    endAngle: CGFloat(7.0 * M_PI / 4.0),
                                    clockwise: false)
        leftPath.lineWidth = 0.0715 * bounds.width
        leftPath.stroke()
        
        let rightX = center.x + (radius/2) * CGFloat(sin(M_PI / 4.0))
        let rightCenter = CGPoint(x: rightX, y : leftY)
        arcColor.setStroke()
        let rightPath = UIBezierPath(arcCenter: rightCenter,
                                    radius: 0.0715 * bounds.width / 2,
                                    startAngle: CGFloat(3.0 * M_PI / 4.0),
                                    endAngle: CGFloat(5.0 * M_PI / 4.0),
                                    clockwise: true)
        rightPath.lineWidth = 0.0715 * bounds.width
        rightPath.stroke()

    }


}
