import UIKit

class GradientView: UIView {
    
    var gradColors = [UIColor]()
    
    var bordersOfRanges : [(min : Float, max : Float)] = [(0,1),(1,2),(2,3),(3,4),(4,5)]
    var valuesOfRanges = [1, 1, 1, 1, 1]
    var gradientlength = 5
    var angleOfValue = CGFloat(3.0 * M_PI / 10.0)
    
    @IBInspectable var gradColor_1: UIColor = UIColor.gray
    @IBInspectable var gradColor_2: UIColor = UIColor.gray
    @IBInspectable var gradColor_3: UIColor = UIColor.gray
    @IBInspectable var gradColor_4: UIColor = UIColor.gray
    @IBInspectable var gradColor_5: UIColor = UIColor.gray
    
    private var gradientWidth = CGFloat()
    private let ratio : CGFloat = 0.125
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        
    }
    
    override func draw(_ rect: CGRect) {
        
        gradColors = [gradColor_1, gradColor_2, gradColor_3, gradColor_4, gradColor_5]
        
        gradientWidth = bounds.width * ratio
        
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = bounds.height
        
        var startAngle: CGFloat = CGFloat(3.0 * M_PI / 4.0)
        
        let leftX = center.x - (radius/2 - gradientWidth/2) * CGFloat(sin(M_PI / 4.0)) - 0.5
        let leftY = center.y + (radius/2 - gradientWidth/2) * CGFloat(cos(M_PI / 4.0)) - 0.5
        let leftCenter = CGPoint(x: leftX, y : leftY)
        gradColors[0].setStroke()
        let leftPath = UIBezierPath(arcCenter: leftCenter,
                                radius: gradientWidth/4,
                                startAngle: startAngle,
                                endAngle: CGFloat(7.0 * M_PI / 4.0),
                                clockwise: false)
        leftPath.lineWidth = gradientWidth/2
        leftPath.stroke()

        
        for i in 0...4 {
            
            gradColors[i].setStroke()
            
            let endAngle: CGFloat = startAngle + angleOfValue * CGFloat(valuesOfRanges[i])
            let path = UIBezierPath(arcCenter: center,
                                    radius: radius/2 - gradientWidth/2,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
            
            path.lineWidth = gradientWidth
            path.stroke()
            
            startAngle = startAngle + angleOfValue * CGFloat(valuesOfRanges[i])
        }
        
        
        let RightX = center.x + (radius/2 - gradientWidth/2) * CGFloat(sin(M_PI / 4.0)) + 0.5
        let RightCenter = CGPoint(x: RightX, y : leftY)
        gradColors[4].setStroke()
        let rightPath = UIBezierPath(arcCenter: RightCenter,
                                radius: gradientWidth/4,
                                startAngle: startAngle,
                                endAngle: CGFloat(5.0 * M_PI / 4.0),
                                clockwise: true)
        rightPath.lineWidth = gradientWidth/2
        rightPath.stroke()

        
        
    }

    func calculateRanges() {

        var min : Float = Float(Network.shared.data.getMin)
        let max : Float = Float(Network.shared.data.getMax)
        let interval : Float = (max - min)/5
        bordersOfRanges = bordersOfRanges.map({ _ -> (min: Float, max: Float) in
            let temp = (min, min + interval)
            min = min + interval
            return temp
        })
        
        let allData = Network.shared.data.all
        
        var sumTemps = 0
        allData.forEach { element in
            sumTemps += (element.max - element.min + 1)
        }

        let minValueOfRange = (Int(Float(sumTemps)/20) > 0 ? Int(Float(sumTemps)/20) : 1)
        var newValuesOfRanges = [Int](repeating: minValueOfRange, count: 5)

        let newGradientlength = sumTemps + 5 * minValueOfRange
        
        allData.forEach { element in
            for i in 0...4 {
                let min = self.bordersOfRanges[i].min
                let max = self.bordersOfRanges[i].max
                
                
                if Float(element.max) >= min, Float(element.min) < max {
                    
                    if Float(element.min) <= min {
                        if Float(element.max) < max {
                            newValuesOfRanges[i] += element.max - Int(min.rounded(.up)) + 1
                            break
                        }
                        else {
                            newValuesOfRanges[i] += Int(max.rounded(.up)) - Int(min.rounded(.up))
                        }
                    }
                    else if Float(element.max) < max {
                        newValuesOfRanges[i] += element.max - element.min + 1
                        break
                    }
                    else {
                        newValuesOfRanges[i] += Int(max.rounded(.up)) - element.min
                    }
                }
            }
        }
        
        let values = newValuesOfRanges.reduce(0 , +)
        newValuesOfRanges[4] += (newGradientlength - values)
        
        
        gradientlength = newGradientlength
        valuesOfRanges = newValuesOfRanges
        angleOfValue = (CGFloat(3.0 * M_PI / 10.0) * 5.0) / CGFloat(newGradientlength)
    }

}
