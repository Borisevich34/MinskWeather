//
//  DataNetwork.swift
//  MinskWeather
//
//  Created by Pavel Borisevich on 03.11.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

struct DataNetwork {
    
    var current : Int = 0
    var all = [(min : Int, max: Int)]()
    
    var getMin : Int {
        get {
            let min = all.min { $0.min < $1.min }
            return min?.min ?? current
        }
    }
    
    var getMax : Int {
        get {
            let max = all.max { $0.max < $1.max }
            return max?.max ?? current
        }
    }
    
}
