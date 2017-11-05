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
    var currTree:String         // image name
    
    var currMission:String
    var timeLeft:Int
    
    
    override init() {
        initialHP = 3
        maxHP = 10
        missionInterval = 300
        currTree = ""
        missionDuration = 100
        currMission = ""
        timeLeft = 0
    }
    
    init(initialHP: Int, maxHP: Int, missionInterval: Int, missionDuration: Int, currTree: String, currMission: String, timeLeft: Int)
    {
        self.initialHP = initialHP
        self.maxHP = maxHP
        self.missionDuration = missionDuration
        self.missionInterval = missionInterval
        self.currTree = currTree
        self.currMission = currMission
        self.timeLeft = timeLeft
    }
}
