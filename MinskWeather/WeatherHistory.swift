//
//  WeatherHistory.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 23.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherHistory {
    
    static let shared = WeatherHistory()
    private var alamofireManager : SessionManager?
    
    var minTemp : Int16 = 0
    var maxTemp : Int16 = 0
    var currentTemp : Int16 = 0
    
    var angle = CGFloat()
    var duration : (left: Double, right: Double) = (0, 0)
    init() {
        let configuration = URLSessionConfiguration.background(withIdentifier: "background")
        configuration.timeoutIntervalForRequest = 5
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func loadHistory(completion: @escaping (Bool)->()) {
        
        alamofireManager?.request("http://api.openweathermap.org/data/2.5/weather?q=Minsk&APPID=b4474caa975a1f5b5c4f8362b59a31b8&units=metric").responseJSON { [unowned self] response in

            switch response.result {
            case .success (let value):
                
                self.parseCurrentJson(JSON(value))
                self.alamofireManager?.request("http://api.openweathermap.org/data/2.5/forecast/daily?q=Minsk&mode=json&units=metric&cnt=16&appid=b4474caa975a1f5b5c4f8362b59a31b8").responseJSON { [unowned self] response in
                
                    switch response.result {
                    case .success (let value):
                        self.parseRangeJson(JSON(value))
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
                
            case .failure:
                completion(false)
            }
            
        }
    }
    
    func parseCurrentJson(_ json: JSON) {
        currentTemp = json["main"]["temp"].int16!
        minTemp = currentTemp
        maxTemp = currentTemp
    }
    
    func parseRangeJson(_ json: JSON) {
        let list = json["list"].array
        list?.forEach({ element in
            let min = element["temp"]["min"].int16!
            let max = element["temp"]["max"].int16!
            if min < minTemp {
                minTemp = min
            }
            if max > maxTemp {
                maxTemp = max
            }
        })
        
        if maxTemp - currentTemp >= currentTemp - minTemp {

            angle = (CGFloat(2 * currentTemp - maxTemp - minTemp) / (CGFloat(maxTemp - minTemp))) *  CGFloat(M_PI/1.65)
            let rightDuration : Double = ((Double(maxTemp + minTemp - 2 * currentTemp)) / (Double(maxTemp - minTemp))) * 2
            duration = (2.5 - rightDuration, rightDuration)
            
        }
        else {
            angle = (CGFloat(2 * currentTemp - maxTemp - minTemp) / (CGFloat(maxTemp - minTemp))) *  CGFloat(M_PI/1.65)
            let leftDuration : Double = ((Double(2 * currentTemp - maxTemp - minTemp)) / (Double(maxTemp - minTemp))) * 2
            duration = (leftDuration, 2.5 - leftDuration)
        }
    }
    
}
