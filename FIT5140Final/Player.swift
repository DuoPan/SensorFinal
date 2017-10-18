//
//  Player.swift
//  FIT5140Final
//
//  Created by duo pan on 18/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class Player: NSObject {
    var name: String
    var password: String
    override init() {
        name = ""
        password = ""
    }
    
    init(name:String,password:String)
    {
        self.name = name
        self.password = password
    }
}
