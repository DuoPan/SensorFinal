//
//  GameController.swift
//  FIT5140Final
//
//  Created by duo pan on 6/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class GameController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var points: UILabel!
    @IBOutlet var mission: UILabel!
    @IBOutlet var timeleft: UILabel!
    @IBOutlet var target: UILabel!
    @IBOutlet var nextMissionTimeLeft: UILabel!
    
    
    var settings: GameSetting!
    var allMissions : [String]!
    var missionTime:Int!
    var nextMissionTime: Int!
    var timerCurMission:Timer!
    var timerNextMission:Timer!
    var timer = Timer() // fetch sensor data
    var isMission:Bool! = true
    var curPoints: Int!
    var tarPoints:Int!
    var missionNo = 0
    var curLowTemp: Int!
    var curHighTemp: Int!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change words on Navigation bar back item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "加个啥呢", style: .done, target: self, action: #selector(menu))

        
        
        curPoints = settings.initialHP
        tarPoints = settings.maxHP
        target.text?.append(String(settings.maxHP))
        points.text = String(settings.initialHP)
        mission.text = allMissions[missionNo]
        nextMissionTime = settings.missionInterval
        timerNextMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                               selector:#selector(self.tickDown2),
                                               userInfo:nil,repeats:true)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                     selector: #selector(self.fetchData),
                                     userInfo: nil, repeats: true)
        
        startMission()
        calcPicture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func calcPicture()
    {
        if curPoints < tarPoints / 3 {
            imageView.image = #imageLiteral(resourceName: "t1")
        }
        else if curPoints >= tarPoints / 3 && curPoints < tarPoints * 2 / 3
        {
            imageView.image = #imageLiteral(resourceName: "t2")
        }
        else if curPoints >= tarPoints * 2 / 3 && curPoints < tarPoints
        {
            imageView.image = #imageLiteral(resourceName: "t3")
        }
        else
        {
            imageView.image = #imageLiteral(resourceName: "t4")
        }
    }
    
    func startMission()
    {
        missionTime = 10
        isMission = true
        getCurData()
        timerCurMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                               selector:#selector(self.tickDown1),
                                               userInfo:nil,repeats:true)
    }
    
    func tickDown1()
    {
        timeleft.text = "Time Left \(missionTime!) s"
        missionTime! -= 1
        if(missionTime <= 0)
        {
            timerCurMission.invalidate()
            finishMission(isSuccess: false)
        }
    }
    
    func tickDown2()
    {
        nextMissionTimeLeft.text = "Next Mission Will in \(nextMissionTime!) s"
        nextMissionTime! -= 1
        if(nextMissionTime <= 0)
        {
            nextMissionTime = settings.missionInterval
            startMission()
        }
    }
    
    func finishMission(isSuccess:Bool)
    {
        timeleft.text = "No event now"
        isMission = false
        if(isSuccess)
        {
            curPoints! += 1
        }
        else
        {
            curPoints! -= 1
        }
        
        if (curPoints! == 0)
        {
            print("game over")
        }
        if (curPoints! == tarPoints)
        {
            print("Win")
        }
        missionNo += 1
        calcPicture()
        addHistory()
    }

    
    func fetchData()
    {
        download()
        if isMission
        {
            judge()
        }
        else
        {
            gather()
        }
    }
    
    func download()
    {
    }
    
    func judge()
    {
       // allMissions[missionNo]
    }
    
    func gather()
    {
        
    }
    
    func addHistory()
    {
        
    }
    
    func getCurData()
    {
        
    }

    // go to login page
    func menu(){
        // set menu
        let menu = UIAlertController(title: "Exit", message: "Do you want to save this game?", preferredStyle: .actionSheet)
        let option1 = UIAlertAction(title: "Save and exit", style: .default){ (_) in self.saveGame()}
        let option2 = UIAlertAction(title: "Exit without saving", style: .default){(_) in self.exitGame() }
        let optionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        menu.addAction(option1)
        menu.addAction(option2)
        menu.addAction(optionCancel)
        self.present(menu, animated: true, completion: nil)
        
        
        

    }
    
    func saveGame()
    {
        
        
        
        
        //reference:
        //https://github.com/cemolcay/GiFHUD-Swift
        GiFHUD.setGif("hud1.gif")
        GiFHUD.showForSeconds(1)
    }
    
    func exitGame()
    {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    // pop up a dialog to show message 1.5 seconds
    func showMessage(msg:String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // reference:
    // https://github.com/MinMao-Hub/MMShareSheet
    @IBAction func showMenu(_ sender: Any) {
        let cards = [
            [
                [
                    "title": "History",
                    "icon": "history",
                    "handler": "gotoHistory"
                ],[
                    "title": "Environment",
                    "icon": "environment",
                    "handler": "gotoEnvironment"
                ],[
                    "title": "Profile",
                    "icon": "profile",
                    "handler": "gotoProfile",
                ],[
                    "title": "支付宝",
                    "icon": "airpay",
                    "handler": "airpay",
                ],[
                    "title": "新浪微博",
                    "icon": "sina",
                    "handler": "sinawb",
                ]
            ],[
                [
                    "title": "Save",
                    "icon": "savegame",
                    "handler": "savegame"
                ],[
                    "title": "Save & Exit",
                    "icon": "saveexitgame",
                    "handler": "saveexitgame"
                ],[
                    "title": "Exit",
                    "icon": "exitgame",
                    "handler": "exitgame"
                ]
            ]]
        let cancelBtn = [
            "title": "Cancel",
            "handler": "cancel",
            "type": "default",
            ]
        let mmShareSheet = MMShareSheet.init(title: "Please Select", cards: cards, duration: nil, cancelBtn: cancelBtn)
        mmShareSheet.callBack = { (handler) -> () in
            if handler != "cancel" {
                if handler == "savegame" {
                    self.saveGame()
                }
                else if handler == "saveexitgame"
                {
                    
                }
                else if handler == "exitgame"
                {
                    self.navigationController!.popToRootViewController(animated: true)
                }
                else{
                    self.performSegue(withIdentifier: handler, sender: self.view)
                }
            }
        }
        mmShareSheet.present()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
