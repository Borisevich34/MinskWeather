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

class Network {
    
    static let shared = Network()
    
    var data = DataNetwork()
    
    private var alamofireManager : SessionManager?
    
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
        
        data.current = json["main"]["temp"].int!
    }
    
    func parseRangeJson(_ json: JSON) {
        
        let list = json["list"].array
        list?.forEach({ element in
            
            data.all.append((element["temp"]["min"].int!, element["temp"]["max"].int!))
        })
        
    }
    
}
