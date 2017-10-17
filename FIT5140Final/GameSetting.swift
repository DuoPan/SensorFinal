//
//  GameSetting.swift
//  FIT5140Final
//
//  Created by duo pan on 6/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class GameSetting: NSObject {
    
    var initialHP: Int
    var maxHP: Int
    var missionInterval: Int
    var lowTemperature: Int
    var highTemperature: Int
    
    var missions = ["The tree is on fire", "The tree feels cold", "The tree feels hot"]
    
    override init() {
        initialHP = 3
        maxHP = 10
        missionInterval = 30
        lowTemperature = 20
        highTemperature = 40
    }
    
    init(initialHP: Int, maxHP: Int, missionInterval: Int, lowTemperature: Int, highTemperature: Int)
    {
        self.initialHP = initialHP
        self.maxHP = maxHP
        self.missionInterval = missionInterval
        self.lowTemperature = lowTemperature
        self.highTemperature = highTemperature
    }
}
