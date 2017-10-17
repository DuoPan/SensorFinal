//
//  InitialController.swift
//  FIT5140Final
//
//  Created by duo pan on 6/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class InitialController: UIViewController {

    @IBOutlet var tfInitialHP: UITextField!
    @IBOutlet var tfMaxHP: UITextField!
    @IBOutlet var tfMissionInterval: UITextField!
    @IBOutlet var tfLowTemp: UITextField!
    @IBOutlet var tfHighTemp: UITextField!
    
 
    var settings = GameSetting()
    var allMissions :[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startNewGame") {
            let controller = segue.destination as! GameController
            getSettings()
            controller.settings = self.settings
            controller.allMissions = self.allMissions
        }
    }
    

    
    func getSettings()
    {
        settings.initialHP = Int(tfInitialHP.text!)!
        settings.maxHP = Int(tfMaxHP.text!)!
        settings.missionInterval = Int(tfMissionInterval.text!)!
        settings.lowTemperature = Int(tfLowTemp.text!)!
        settings.highTemperature = Int(tfHighTemp.text!)!
        let num = settings.maxHP - settings.initialHP
        allMissions.removeAll()
        for _ in 0...num{
            allMissions.append(settings.missions[getRandomMission()])            
        }
    }
    
    func getRandomMission() -> Int
    {
        let range = settings.missions.count
        return Int(arc4random_uniform(UInt32(range)))
    }
}
