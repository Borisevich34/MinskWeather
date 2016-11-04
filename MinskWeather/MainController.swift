//
//  ViewController.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 23.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet weak var arrowView: ArrowView!
    @IBOutlet weak var ghostView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var rangeTemp: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var arcView: ArcView!
    
    var alertController : UIAlertController!
    
    var isAnimate = true
    private var duration : (left: Double, right: Double) = (0, 0)
    private var angle = CGFloat()

    
    var stateAnimation : StateAnimation = .UpToRight
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertController = UIAlertController(title: "Sorry", message: "Try again please", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: {(action) in Network.shared.loadHistory(completion: self.completion)}))

        startAnimating()
        Network.shared.loadHistory(completion: completion)
        
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
                else if self.stateAnimation.isAngleInState(angle: self.angle) {
                    
                    self.gradientView.calculateRanges()
                    
                    let newParameters = self.stateAnimation.getParameters()
                    let pinDuration = self.stateAnimation.isNeedRightDuration() ? self.duration.right : self.duration.left
                    let options = newParameters.options == UIViewAnimationOptions.curveEaseIn ? UIViewAnimationOptions.curveEaseInOut: newParameters.options
                    
                    UIView.animate(withDuration: pinDuration, delay: newParameters.delay, options: options, animations:
                        {  [unowned self] in
                            
                            self.arrowView.layer.transform = CATransform3DMakeRotation(self.angle, 0, 0, 1)
                        }, completion:
                        { [unowned self] _ in
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                self.gradientView.alpha = 0
                                self.arcView.alpha = 0
                                }, completion: { [unowned self] _ in
                                    self.gradientView.setNeedsDisplay()
                                    
                                    UIView.animate(withDuration: 0.5, animations: {
                                        self.gradientView.alpha = 1
                                        self.arcView.alpha = 0.1
                                        })
                                })

                            
                            self.currentTemp.text = "\(Network.shared.data.current) ºC"
                            self.rangeTemp.text = "\(Network.shared.data.getMin) ºC  to  \(Network.shared.data.getMax) ºC"
                            UIView.animate(withDuration: 1, animations: {
                                self.ghostView.alpha = 1
                                self.currentTemp.alpha = 1
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
            self.currentTemp.alpha = 0
            })
            { _ in
                if self.angle != 0 {
                    
                    var pinDuration : Double
                    if self.angle > 0 {
                        self.stateAnimation = .RightToUp
                        pinDuration = self.duration.left
                    }
                    else {
                        self.stateAnimation = .LeftToUp
                        pinDuration = self.duration.right
                    }
                    
                    UIView.animate(withDuration: pinDuration, delay: 0.5, options: .curveEaseIn, animations:
                        { [unowned self] in
                            self.arrowView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1)
                        }, completion: { _ in
                            self.isAnimate = true
                            self.startAnimating()
                            Network.shared.loadHistory(completion: self.completion)
                    })
                    
                }
                else {
                    self.isAnimate = true
                    self.startAnimating()
                    Network.shared.loadHistory(completion: self.completion)
                }
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func completion(isSuccess: Bool) {
        if isSuccess {
        
            calculateAnimation()
            isAnimate = false
        }
        else {
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func calculateAnimation() {
        
        let max = Network.shared.data.getMax
        let min = Network.shared.data.getMin
        let current = Network.shared.data.current
        
        if max - current >= current - min {
            
            angle = (CGFloat(2 * current - max - min) / (CGFloat(max - min))) *  CGFloat(M_PI/1.65)
            let rightDuration : Double = ((Double(max + min - 2 * current)) / (Double(max - min))) * 2
            duration = (2.5 - rightDuration, rightDuration)
            
        }
        else {
            angle = (CGFloat(2 * current - max - min) / (CGFloat(max - min))) *  CGFloat(M_PI/1.65)
            let leftDuration : Double = ((Double(2 * current - max - min)) / (Double(max - min))) * 2
            duration = (leftDuration, 2.5 - leftDuration)
        }
    }
}

