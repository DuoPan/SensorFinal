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
    var missionDuration: Int
    var lowTemperature: Int
    var highTemperature: Int
    var currTree:String
    
    var missions = ["On fire", "Too cold", "Too hot"]
    
    override init() {
        initialHP = 3
        maxHP = 10
        missionInterval = 300
        lowTemperature = 20
        highTemperature = 40
        currTree = ""
        missionDuration = 100
    }
    
    init(initialHP: Int, maxHP: Int, missionInterval: Int, missionDuration: Int, lowTemperature: Int, highTemperature: Int, currTree: String)
    {
        self.initialHP = initialHP
        self.maxHP = maxHP
        self.missionDuration = missionDuration
        self.missionInterval = missionInterval
        self.lowTemperature = lowTemperature
        self.highTemperature = highTemperature
        self.currTree = currTree
    }
}
