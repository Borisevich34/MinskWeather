//
//  ViewController.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 23.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
                return angle >= 0
            case .RightToUp:
                return angle >= 0
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
    
    @IBOutlet weak var arrowView: ArrowView!
    @IBOutlet weak var ghostView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var rangeTemp: UILabel!
    
    var alertController : UIAlertController!
    var isAnimate = true

    var stateAnimation : StateAnimation = .UpToRight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertController = UIAlertController(title: "Sorry", message: "Try again please", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action) in WeatherHistory.shared.loadHistory(completion: self.completion)}))

        startAnimating()
        WeatherHistory.shared.loadHistory(completion: completion)
        
    }

    func startAnimating() {
            
        let parameters = stateAnimation.getParameters()
        UIView.animate(withDuration: 2, delay: parameters.delay, options: parameters.options, animations:
            {  [unowned self] in
                self.arrowView.layer.transform = CATransform3DMakeRotation(parameters.angle, 0, 0, 1)
            }, completion:
            {  _ in
                self.stateAnimation.next()
                if self.isAnimate {
                    self.startAnimating()
                }
                else if self.stateAnimation.isAngleInState(angle: WeatherHistory.shared.angle) {
                    
                    let newParameters = self.stateAnimation.getParameters()
                    let duration = self.stateAnimation.isNeedRightDuration() ? WeatherHistory.shared.duration.right : WeatherHistory.shared.duration.left
                    let options = newParameters.options == UIViewAnimationOptions.curveEaseIn ? UIViewAnimationOptions.curveEaseInOut: newParameters.options
                    
                    UIView.animate(withDuration: duration, delay: newParameters.delay, options: options, animations:
                        {  [unowned self] in
                            
                            self.arrowView.layer.transform = CATransform3DMakeRotation(WeatherHistory.shared.angle, 0, 0, 1)
                        }, completion:
                        { [unowned self] _ in
                            self.currentTemp.text = "Current temperature  \(WeatherHistory.shared.currentTemp) ºC"
                            self.rangeTemp.text = "\(WeatherHistory.shared.minTemp) ºC  to  \(WeatherHistory.shared.maxTemp) ºC"
                            UIView.animate(withDuration: 1, animations: {
                                self.ghostView.alpha = 1
                                }, completion: { [unowned self] _ in
                                    self.updateButton.isEnabled = true
                                })
                            
                        })
                }
                else {
                    self.startAnimating()
                }
            })
    }

    @IBAction func updatePressed(_ sender: AnyObject) {
        updateButton.isEnabled = false
        UIView.animate(withDuration: 1, animations: { 
            self.ghostView.alpha = 0
            })
            { _ in
                
                let parameters = self.stateAnimation.getParameters()
                let duration = self.stateAnimation.isNeedRightDuration() ? WeatherHistory.shared.duration.left : WeatherHistory.shared.duration.right
                let options = parameters.options == UIViewAnimationOptions.curveEaseOut ? UIViewAnimationOptions.curveEaseInOut: parameters.options
                
                UIView.animate(withDuration: duration, delay: 0.5, options: options, animations:
                    { [unowned self] in
                    
                    self.arrowView.layer.transform = CATransform3DMakeRotation(parameters.angle, 0, 0, 1)
                    }, completion: { _ in
                        self.isAnimate = true
                        self.startAnimating()
                        WeatherHistory.shared.loadHistory(completion: self.completion)
                })
                
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func completion(isSuccess: Bool) {
        if isSuccess {
            isAnimate = false
        }
        else {
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

