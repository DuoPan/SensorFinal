//
//  EnvironmentData.swift
//  FIT5140Final
//
//  Created by duo pan on 19/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
// store environment data, till now we only use temperature and humidity
class EnvironmentData: NSObject {
    var temperature: Int
    var humidity: Int
    var light: Int
    var rain: Int
    var fire: Int
    
    override init() {
        temperature = 0
        humidity = 0
        light = 0
        rain = 0
        fire = 0
    }
    
    init(t:Int, h:Int) {
        self.temperature = t
        self.humidity = h
        self.light = 0
        self.rain = 0
        self.fire = 0
    }
    
    init(env:EnvironmentData) {
        self.temperature = env.temperature
        self.humidity = env.humidity
        self.light = env.light
        self.rain = env.rain
        self.fire = env.fire
    }
}
