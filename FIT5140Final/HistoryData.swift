//
//  HistoryData.swift
//  FIT5140Final
//
//  Created by duo pan on 20/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class HistoryData: NSObject {
    var number:Int
    var name:String
    var valueChange:Int     //add or delete score
    var totalScore:Int
    
    override init() {
        number = 0
        name = ""
        valueChange = 0
        totalScore = 0
    }
    
    init(number:Int, name:String, valueChange:Int, totalScore:Int)
    {
        self.number = number
        self.name = name
        self.valueChange = valueChange
        self.totalScore = totalScore
    }
}
