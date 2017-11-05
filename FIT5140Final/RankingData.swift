//
//  RankingData.swift
//  FIT5140Final
//
//  Created by duo pan on 22/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class RankingData: NSObject {
    var name:String
    var score:Int
    var rank:Int
    
    init(name:String, score:Int)
    {
        self.name = name
        self.score = score
        self.rank = 0
    }
}
