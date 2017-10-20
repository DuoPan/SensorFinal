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
    var firebaseObserverID: UInt?
    
    var username:String!
    var settings: GameSetting!
    var histories:[HistoryData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .done, target: self, action: #selector(exitGame))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        firebaseRef!.removeObserver(withHandle: firebaseObserverID!)
    }
    
    func exitGame()
    {
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func loadGame(_ sender: Any) {
        settings = GameSetting()
        histories = []
        
        firebaseRef = Database.database().reference(withPath:"Savings/Players")
        firebaseObserverID = firebaseRef!.observe(DataEventType.value, with: {(snapshot) in
            if !snapshot.hasChild(self.username)
            {
                self.showMessage(msg: "You do not have a file")
                return
            }
            else
            {
                let ref = self.firebaseRef?.child(self.username + "/currentGame")
                self.firebaseObserverID = ref!.observe(DataEventType.value, with: {(snapshot) in
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
                            //print(array.count)
                            // acutall 3 in firebase, I dont know why it is 4 here
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
        }
    }
    

}
