//
//  EnvironmentData.swift
//  FIT5140Final
//
//  Created by duo pan on 19/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class EnvironmentData: NSObject {
    var temperature: Int
    
    override init() {
        temperature = 0
    }
    
    init(t:Int) {
        self.temperature = t
    }
}
