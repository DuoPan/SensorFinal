//
//  MainController.swift
//  FIT5140Final
//
//  Created by duo pan on 5/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
import Firebase

class MainController: UIViewController {

    var firebaseRef: DatabaseReference?
    var firebaseObserverID: UInt?       //observer user info
    var firebaseObserverID2: UInt?      //observer game history
    
    var username:String!                //user name
    var settings: GameSetting!          //store game setting data if user choose load game
    var histories:[HistoryData]!        //store game history data if user choose load game
    var totalScore:Int!                 //load total score since registration from firebase
    
    var removeObseverTag:Int!           //if load game, or load fail, remove more observers
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .done, target: self, action: #selector(exitGame))
        
        removeObseverTag = 0
        download()
    }

    // download total score
    func download(){
        firebaseRef = Database.database().reference(withPath:"Savings/Players")
        firebaseRef?.child(self.username).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let score = value?["score"] as? Int
            if score == nil{
                self.totalScore = 0
            }else{
                self.totalScore = score
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // remove observers, otherwise problems will be happen when saving game
    override func viewDidDisappear(_ animated: Bool) {
        firebaseRef!.child(self.username).removeAllObservers() // remove an observer used in download
        if removeObseverTag == 1{
            firebaseRef!.removeObserver(withHandle: firebaseObserverID!)
        }
        else if removeObseverTag == 2 {
            firebaseRef!.removeObserver(withHandle: firebaseObserverID!)
            firebaseRef!.child(self.username + "/currentGame").removeObserver(withHandle: firebaseObserverID2!)
        }
    }
    
    func exitGame()
    {
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func loadGame(_ sender: Any) {
        settings = GameSetting()
        histories = []
        
        // check if the user have a saving file
        firebaseObserverID = firebaseRef!.observe(DataEventType.value, with: {(snapshot) in
            if !snapshot.hasChild(self.username)
            {
                self.showMessage(msg: "You do not have a file")
                self.removeObseverTag = 1//need to remove 1 observer
                return
            }
            else// get all setting data
            {
                self.firebaseObserverID2 = self.firebaseRef!.child(self.username + "/currentGame").observe(DataEventType.value, with: {(snapshot) in
                    for child in snapshot.children{
                        let snap = child as! DataSnapshot
                        if(snap.key == "duration"){
                            self.settings.missionDuration = snap.value as! Int
                        }else if(snap.key == "interval"){
                            self.settings.missionInterval = snap.value as! Int
                        }else if(snap.key == "score"){
                            self.settings.initialHP = snap.value as! Int
                        }else if(snap.key == "target"){
                            self.settings.maxHP = snap.value as! Int
                        }else if(snap.key == "treeName"){
                            self.settings.currTree = snap.value as! String
                        }else if(snap.key == "timeLeft"){
                            self.settings.timeLeft = snap.value as! Int
                        }else if(snap.key == "currMission"){
                            self.settings.currMission = snap.value as! String
                        }else if(snap.key == "history"){
                            let array = snap.value as! NSArray
                            // acutally 3 in firebase, I dont understand why it is 4 here
                            // so I have to remove NSNull here
                            for case let item as NSObject in array {
                                if item is NSNull{
                                    continue
                                }
                                let dict = item as! [String:AnyObject]
                                let his = HistoryData()
                                his.name = dict["name"] as! String
                                his.number = dict["number"] as! Int
                                his.totalScore = dict["total"] as! Int
                                his.valueChange = dict["vc"] as! Int
                                self.histories.append(his)
                            }
                        }
                    }
                    // must put before return
                    self.removeObseverTag = 2//need to remove 2 observers
                    // can not load a finished game
                    if(self.settings.initialHP == self.settings.maxHP){
                        self.showMessage(msg: "You have finished last game, please start a new game")
                        return
                    }
                    self.performSegue(withIdentifier: "loadGame", sender: self.view)
                })
            }
        })
    }
    
    func showMessage(msg:String){
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loadGame") {
            let controller = segue.destination as! GameController
            controller.settings = self.settings
            controller.username = self.username
            controller.historyList = self.histories
            controller.totalScore = self.totalScore
        }
        if (segue.identifier == "gotoInitial") {
            let controller = segue.destination as! InitialController
            controller.username = self.username
            controller.totalScore = self.totalScore
        }
    }
    

}
