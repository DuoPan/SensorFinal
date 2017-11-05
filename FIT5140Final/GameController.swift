//
//  GameController.swift
//  FIT5140Final
//
//  Created by duo pan on 6/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//
// This controller implements main game logic. Random missions are generated after a time interval and user need to do something to complete the mission. There is an alarm function in this controller that monitors flame sensor, when tree is on fire, an alarm mission 'on fire' will occur and interrupt the current process.

import UIKit
import Firebase

class GameController: UIViewController {
    

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var points: UILabel!
    @IBOutlet var mission: UILabel!
    @IBOutlet var timeleft: UILabel!
    @IBOutlet var target: UILabel!
    @IBOutlet var progressView: UIProgressView!
    
    //firebase reference
    var firebaseRef: DatabaseReference?
    
    var username:String!
    var settings: GameSetting!
    var missionTime:Int!
    var nextMissionTime: Int!
    var timerMission:Timer!
    var timerJudge: Timer!
    var timerAlarm: Timer!
    var curPoints: Int!
    var tarPoints:Int!
    var currMission: Int!
    var missionEnv:EnvironmentData!
    var currEnv:EnvironmentData!
    var historyNo: Int!
    var historyList:[HistoryData]!
    var totalScore:Int!
    
    //pre-defined mission array. On fire is the alarm mission
    var missions = ["Water tree", "Need light", "Too cold", "Too hot", "On fire"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currEnv = EnvironmentData()
        
        // Change words on Navigation bar back item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)

        curPoints = settings.initialHP
        tarPoints = settings.maxHP
        target.text?.append(String(settings.maxHP))
        points.text = "Current Health Credits: \(String(settings.initialHP))"
        
        historyNo = historyList.count
        
        //set alarm timer
        timerAlarm = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                          selector:#selector(self.alarm),
                                          userInfo:nil,repeats:true)
        
        //if there is no current mission, running mission generating process. tickDown2 is a function for mission generating countdown
        if(settings.currMission == "no")
        {
            progressView.progress = 1 - (Float(settings.timeLeft) / Float(settings.missionInterval))
            nextMissionTime = settings.timeLeft
            timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                selector:#selector(self.tickDown2),
                                                userInfo:nil,repeats:true)
            mission.text = "Current Mission:    nothing"
            missionTime = 0
        }
        //otherwise run mission complete countdown
        else{
            progressView.progress = 1 - (Float(settings.timeLeft) / Float(settings.missionDuration))
            missionTime = settings.timeLeft
            mission.text = "Current Mission:    \(settings.currMission)"
            
            for i in 0...missions.count {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //tree picture will change as current credit changes. we set four figures here
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
    
    //this function is about starting a mission. Triggering the judge timmer and set mission timer to tickDown1
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
    //this function is for mission completing countdown. when a mission is generated, this function will be triggered.
    func tickDown1()
    {
        timeleft.text = "Time Left \(missionTime!) s"
        missionTime! -= 1
        progressView.progress += 1.0 / Float(settings.missionDuration)
        if(missionTime < 0)
        {
            timerMission.invalidate()
            timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                  selector:#selector(self.tickDown2),
                                                  userInfo:nil,repeats:true)
            timerJudge.invalidate()
            finishMission(isSuccess: false)
            progressView.progress = 0
        }
    }
    //this function is for mission generating countdown. after a mission is completed, this function will be triggered.
    func tickDown2()
    {
        timeleft.text = "Next Mission Will in \(nextMissionTime!) s"
        nextMissionTime! -= 1
        progressView.progress += 1.0 / Float(settings.missionInterval)
        if(nextMissionTime < 0)
        {
            nextMissionTime = settings.missionInterval
            timerMission.invalidate()
            startMission()
            progressView.progress = 0
        }
    }
    
    //This function is used to handle the behavior after a mission is completed. If a mission is completed correctly, current credit will be added. Otherwise, it will minus 1 credit. 
    func finishMission(isSuccess:Bool)
    {
        timeleft.text = ""
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
        points.text = "Current Health Credits: \(String(curPoints))"
        
        if (curPoints! == 0)
        {
            print("game over")
            exitGame() // this line must put before showMessage
            showMessage(msg: "Lose Game")
           // GiFHUD.setGif("gameover.png")
           // GiFHUD.showForSeconds(2)
            return
        }
        if (curPoints! == tarPoints)
        {
            print("Win")
            saveGame()
            exitGame()
            showMessage(msg: "You Win")
            return
        }
        
        mission.text = "Current Mission:    Nothing"
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
//        currEnv.temperature = 25 // example
        var url: URL
        //url = URL(string: "http://192.168.1.103:8080/temperature")!
        url = URL(string: "https://duopan.github.io")!
        
        // fast method to get data
        guard let envJsonData = NSData(contentsOf: url) else { return }
        let jsonData = JSON(envJsonData)
        if jsonData["temperature"].int != nil && jsonData["humidity"].int != nil && jsonData["light"].int != nil && jsonData["rain"].int != nil && jsonData["fire"].int != nil
        {
            currEnv.temperature = jsonData["temperature"].int!;
            currEnv.humidity = jsonData["humidity"].int!;
            currEnv.light = jsonData["light"].int!;
            currEnv.rain = jsonData["rain"].int!;
            currEnv.fire = jsonData["fire"].int!;
        }
    }
    
    func alarm()
    {
        download()
        if (currEnv.rain == 0)
        {
            if (timerJudge != nil)
            {
                timerJudge.invalidate()
            }
            
            missionTime = settings.missionDuration
            timerMission.invalidate()
            //start an alarm mission
            missionEnv = EnvironmentData(env: currEnv)
            currMission = 4 //on fire mission
            mission.text = "Current Mission:    \(missions[currMission])"
            timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                selector:#selector(self.tickDown1),
                                                userInfo:nil,repeats:true)
            timerJudge = Timer.scheduledTimer(timeInterval: 5, target: self,
                                              selector: #selector(self.judge),
                                              userInfo: nil, repeats: true)
            timerAlarm.invalidate()
            
            nextMissionTime = settings.missionInterval
            progressView.progress = 0

        }
    }
    
    func judge()
    {
        download()
        switch currMission
        {
        case 0: // need water
            if currEnv.rain == 0
            {
                timerMission.invalidate()
                timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                    selector:#selector(self.tickDown2),
                                                    userInfo:nil,repeats:true)
                timerJudge.invalidate()
                finishMission(isSuccess: true)
                progressView.progress = 0
            }
            break
            
        case 1: // need light
            if currEnv.light == 0
            {
                timerMission.invalidate()
                timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                    selector:#selector(self.tickDown2),
                                                    userInfo:nil,repeats:true)
                timerJudge.invalidate()
                finishMission(isSuccess: true)
                progressView.progress = 0
                
            }
            break
            
        case 2: // Too cold
            if currEnv != nil
            {
                if currEnv.temperature - missionEnv.temperature > 1 // become colder
                {
                    timerMission.invalidate()
                    timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                        selector:#selector(self.tickDown2),
                                                        userInfo:nil,repeats:true)
                    timerJudge.invalidate()
                    finishMission(isSuccess: true)
                    progressView.progress = 0
                }
            }
            break
            
        case 3: // Too hot
            if currEnv != nil
            {
                if currEnv.temperature - missionEnv.temperature < -1 // become colder
                {
                    timerMission.invalidate()
                    timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                        selector:#selector(self.tickDown2),
                                                        userInfo:nil,repeats:true)
                    timerJudge.invalidate()
                    finishMission(isSuccess: true)
                    progressView.progress = 0
                }
            }
            
            break
            
        case 4: // On fire
            if currEnv.rain == 1 // no fire now
            {
                timeleft.text = ""
                mission.text = "Current Mission:    Nothing"
                missionTime = 0

                timerMission.invalidate()
                timerMission = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                    selector:#selector(self.tickDown2),
                                                    userInfo:nil,repeats:true)
                timerJudge.invalidate()
                timerAlarm = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                  selector:#selector(self.alarm),
                                                  userInfo:nil,repeats:true)
                progressView.progress = 0
            }
            break
        default:
            break
        }
        
    }
    
    func getRandomMission() -> Int
    {
        let range = missions.count - 1
        return Int(arc4random_uniform(UInt32(range)))
//        return 1
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
        missionEnv = EnvironmentData(env: currEnv)
        currMission = getRandomMission()
        mission.text = "Current Mission:    \(missions[currMission])"
    }
   
    func saveGame()
    {
        firebaseRef = Database.database().reference(withPath:"Savings/Players/"+self.username)
        
        firebaseRef?.setValue(["score":totalScore])
        
        let newSaving = firebaseRef!.child("currentGame")
        var cm = "no"
        var tf:Int = nextMissionTime
        if nextMissionTime == settings.missionInterval{
            cm = missions[currMission]
            tf = missionTime
        }
      
        newSaving.setValue(["currMission":cm, "duration":settings.missionDuration,
                            "interval":settings.missionInterval, "score":curPoints, "target":tarPoints,
                            "timeLeft":tf, "treeName":settings.currTree])

        if historyList.count > 0 {
            for i in 0...historyList.count-1
            {
                let dict = ["name":historyList[i].name,"number":historyList[i].number,"total":historyList[i].totalScore,"vc":historyList[i].valueChange] as [String : AnyObject]
                firebaseRef!.child("currentGame").child("history").child(String(i+1)).setValue(dict)
            }
        }
        
    }
    
    func exitGame()
    {
        if timerAlarm != nil{
            timerAlarm.invalidate()
        }
        if timerJudge != nil{
            timerJudge.invalidate()
        }
        if timerMission != nil{
            timerMission.invalidate()
        }
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
                    //reference:
                    //https://github.com/cemolcay/GiFHUD-Swift
                    GiFHUD.setGif("hud1.gif")
                    GiFHUD.showForSeconds(0.5)
                }
                else if handler == "saveexitgame"
                {
                    self.saveGame()
                    self.exitGame()
                    GiFHUD.setGif("hud1.gif")
                    GiFHUD.showForSeconds(0.5)
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
        progressView.progress = 0
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
            controller.score = self.totalScore
            controller.treename = self.settings.currTree
        }
    }

    
}
