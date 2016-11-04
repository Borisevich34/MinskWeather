//
//  StateAnimation.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 03.11.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

enum StateAnimation {
    
    case UpToRight
    case RightToUp
    case UpToLeft
    case LeftToUp
    
    mutating func next() {
        switch self {
        case .UpToRight:
            self = .RightToUp
        case .RightToUp:
            self = .UpToLeft
        case .UpToLeft:
            self = .LeftToUp
        case .LeftToUp:
            self = .UpToRight
        }
    }
    
    func isAngleInState(angle: CGFloat) -> (Bool){
        switch self {
        case .UpToRight:
            return angle > 0
        case .RightToUp:
            return angle > 0
        case .UpToLeft:
            return angle <= 0
        case .LeftToUp:
            return angle <= 0
        }
    }
    
    func isNeedRightDuration() -> Bool {
        switch self {
        case .UpToRight:
            return false
        case .RightToUp:
            return true
        case .UpToLeft:
            return true
        case .LeftToUp:
            return false
        }
        
    }
    
    func getParameters() -> (delay : Double, options : UIViewAnimationOptions, angle: CGFloat) {
        switch self {
        case .UpToRight:
            let params: (Double, UIViewAnimationOptions, CGFloat) = (0, .curveEaseOut, CGFloat(M_PI/1.65))
            return params
        case .RightToUp:
            let params: (Double, UIViewAnimationOptions, CGFloat) = (0.5, .curveEaseIn, 0)
            return params
        case .UpToLeft:
            let params: (Double, UIViewAnimationOptions, CGFloat) = (0, .curveEaseOut, -CGFloat(M_PI/1.65))
            return params
        case .LeftToUp:
            let params: (Double, UIViewAnimationOptions, CGFloat) = (0.5, .curveEaseIn, 0)
            return params
        }
    }
}

