//
//  GameController.swift
//  FIT5140Final
//
//  Created by duo pan on 6/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
import Firebase

class GameController: UIViewController {
    

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var points: UILabel!
    @IBOutlet var mission: UILabel!
    @IBOutlet var timeleft: UILabel!
    @IBOutlet var target: UILabel!
    @IBOutlet var nextMissionTimeLeft: UILabel!
    
    
    var firebaseRef: DatabaseReference?
    
    var username:String!
    var settings: GameSetting!
    var missionTime:Int!
    var nextMissionTime: Int!
    var timerMission:Timer!
    var timerJudge: Timer!
    var curPoints: Int!
    var tarPoints:Int!
    var currMission: Int!
    var missionEnv = EnvironmentData()
    var currEnv = EnvironmentData()
    var historyNo: Int!
    var historyList:[HistoryData]!
    var totalScore:Int!
    
    var missions = ["On fire", "Too cold", "Too hot"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Change words on Navigation bar back item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "加个啥呢", style: .done, target: self, action: #selector(menu))

        curPoints = settings.initialHP
        tarPoints = settings.maxHP
        target.text?.append(String(settings.maxHP))
        points.text = String(settings.initialHP)
        historyNo = historyList.count
        
        if(settings.currMission == "no")
        {
            nextMissionTime = settings.timeLeft
            timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                selector:#selector(self.tickDown2),
                                                userInfo:nil,repeats:true)
            mission.text = "nothing"
            missionTime = 0
        }
        else{
            missionTime = settings.timeLeft
            mission.text = settings.currMission
            for var i in 0...missions.count {
                if missions[i] == settings.currMission
                {
                    currMission = i
                    break
                }
            }
            nextMissionTime = settings.missionInterval
            timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                selector:#selector(self.tickDown1),
                                                userInfo:nil,repeats:true)
            timerJudge = Timer.scheduledTimer(timeInterval: 5, target: self,
                                              selector: #selector(self.judge),
                                              userInfo: nil, repeats: true)
        }
        calcPicture()
        
        print("aaa")
        print(self.totalScore)
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
        missionTime = settings.missionDuration
        setMissionData()
        timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                               selector:#selector(self.tickDown1),
                                               userInfo:nil,repeats:true)
        timerJudge = Timer.scheduledTimer(timeInterval: 5, target: self,
                                          selector: #selector(self.judge),
                                          userInfo: nil, repeats: true)
    }
    
    func tickDown1()
    {
        timeleft.text = "Time Left \(missionTime!) s"
        missionTime! -= 1
        if(missionTime <= 0)
        {
            timerMission.invalidate()
            timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                  selector:#selector(self.tickDown2),
                                                  userInfo:nil,repeats:true)
            timerJudge.invalidate()
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
            timerMission.invalidate()
            startMission()
            nextMissionTimeLeft.text = "0"
        }
    }
    
    func finishMission(isSuccess:Bool)
    {
        timeleft.text = "No event now"
        if(isSuccess)
        {
            curPoints! += 1
            print("pass mission")
            totalScore! += 1
        }
        else
        {
            curPoints! -= 1
            print("fail mission")
            totalScore! -= 1
        }
        points.text = String(curPoints)
        
        if (curPoints! == 0)
        {
            print("game over")
            // do sth else
        }
        if (curPoints! == tarPoints)
        {
            print("Win")
            // do sth else
        }
        
        mission.text = "Nothing"
        calcPicture()
        if isSuccess {
            addHistory(vc: 1)
        }
        else{
            addHistory(vc: -1)
        }
        missionTime = 0
    }

    
    func download()
    {
        //获取一组数据
        //然后赋值
        currEnv.temperature = 25 // example
    }
    
    func judge()
    {
        download()
        switch currMission
        {
        case 0: // The tree is on fire
            
            break
        case 1: // The tree feels cold
            if currEnv.temperature - missionEnv.temperature > 1 // become hotter
            {
                finishMission(isSuccess: true)
            }
            break
        case 2: // The tree feels hot
            if currEnv.temperature - missionEnv.temperature < -1 // become colder
            {
                finishMission(isSuccess: true)
            }
            break
        default:
            break
        }
        
    }
    

    
    func addHistory(vc:Int)
    {
        historyNo! += 1
        let his = HistoryData(number: historyNo, name: missions[currMission], valueChange: vc, totalScore: curPoints)
        historyList.append(his)
    }
    
    func setMissionData()
    {
        download()
        missionEnv = currEnv
        currMission = getRandomMission()
        mission.text = missions[currMission]
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
        firebaseRef = Database.database().reference(withPath:"Savings/Players/"+self.username)
        
        firebaseRef?.setValue(["score":totalScore])
        
        let newSaving = firebaseRef!.child("currentGame")
        var cm = "no"
        var tf = nextMissionTime
        if nextMissionTime == settings.missionInterval{
            cm = missions[currMission]
            tf = missionTime
        }
      
        newSaving.setValue(["currMission":cm, "duration":settings.missionDuration,
                            "interval":settings.missionInterval, "score":curPoints, "target":tarPoints,
                            "timeLeft":tf, "treeName":settings.currTree])

        if historyList.count > 0 {
            for var i in 0...historyList.count-1
            {
                let dict = ["name":historyList[i].name,"number":historyList[i].number,"total":historyList[i].totalScore,"vc":historyList[i].valueChange] as [String : AnyObject]
                firebaseRef!.child("currentGame").child("history").child(String(i+1)).setValue(dict)
            }
        }
        
        //reference:
        //https://github.com/cemolcay/GiFHUD-Swift
        GiFHUD.setGif("hud1.gif")
        GiFHUD.showForSeconds(1)
    }
    
    func exitGame()
    {
        navigationController?.setNavigationBarHidden(true, animated: true)
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
                    "icon": "icon_history",
                    "handler": "gotoHistory"
                ],[
                    "title": "Environment",
                    "icon": "icon_env",
                    "handler": "gotoEnvironment"
                ],[
                    "title": "Profile",
                    "icon": "icon_profile",
                    "handler": "gotoProfile",
                ],[
                    "title": "Ranking List",
                    "icon": "icon_rank",
                    "handler": "gotoRanking",
                ],[
                    "title": "To be continue",
                    "icon": "icon_achi",
                    "handler": "gotoAchievements",
                ]
            ],[
                [
                    "title": "Save",
                    "icon": "icon_save",
                    "handler": "savegame"
                ],[
                    "title": "Save & Exit",
                    "icon": "icon_exitsave",
                    "handler": "saveexitgame"
                ],[
                    "title": "Exit",
                    "icon": "icon_exit",
                    "handler": "exitgame"
                ]
            ]]
        let cancelBtn = [
            "title": "Cancel",
            "handler": "cancel",
            "type": "default",
            ]
        let mmShareSheet = MMShareSheet.init(title: "Please Select (Can Slide)", cards: cards, duration: nil, cancelBtn: cancelBtn)
        mmShareSheet.callBack = { (handler) -> () in
            if handler != "cancel" {
                if handler == "savegame" {
                    self.saveGame()
                }
                else if handler == "saveexitgame"
                {
                    self.saveGame()
                    self.exitGame()
                }
                else if handler == "exitgame"
                {
                    self.exitGame()
                }
                else{
                    self.performSegue(withIdentifier: handler, sender: self.view)
                }
            }
        }
        mmShareSheet.present()
    }
    
    func getRandomMission() -> Int
    {
        let range = missions.count
        return Int(arc4random_uniform(UInt32(range)))
    }
    
    @IBAction func cheat(_ sender: Any) {
        if(missionTime <= 0)
        {
            return
        }
        timerMission.invalidate()
        timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                            selector:#selector(self.tickDown2),
                                            userInfo:nil,repeats:true)
        timerJudge.invalidate()
        finishMission(isSuccess: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoHistory") {
            let controller = segue.destination as! HistoryController
            controller.historyList = self.historyList
        }
        if(segue.identifier == "gotoRanking")
        {
            let splitViewController = segue.destination as! UISplitViewController
            let leftNavController = splitViewController.viewControllers.first as! UINavigationController
            let masterViewController = leftNavController.topViewController as! RankingTableController
            let detailViewController = splitViewController.viewControllers.last as! RankingDetailController
            let firstPlayer = masterViewController.players.first
            detailViewController.player = firstPlayer
            masterViewController.delegate = detailViewController
        }
        if(segue.identifier == "gotoProfile")
        {
            let controller = segue.destination as! ProfileController
            controller.username = self.username
        }
    }

    
}
