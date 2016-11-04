//
//  CircleView.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 04.11.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

class CirceView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.lightGray.setFill()
        path.fill()
    }
}
