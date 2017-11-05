//
//  RankingTableController.swift
//  FIT5140Final
//
//  Created by duo pan on 21/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
import Firebase

protocol PlayerSelectionDelegate: class {
    func playerSelected(newPlayer: RankingData)
}

class RankingTableController: UITableViewController{
    fileprivate var collapseDetailViewController = true
    var players = [RankingData]()
    
    var firebaseRef: DatabaseReference?
    var firebaseObserverID: UInt?
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        download()
    }
    
    weak var delegate: PlayerSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToPrevious))
        
    }
    
    func download()
    {
        firebaseRef = Database.database().reference(withPath:"Savings/Players")
        firebaseObserverID = firebaseRef!.observe(DataEventType.value, with: {(snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: AnyObject]
                let s = dict["score"] as! Int
                let n = snap.key
                let p = RankingData(name:n,score:s)
                self.players.append(p)
            }
            self.players.sort(by: {$0.score > $1.score})
        })

    }

    func backToPrevious()
    {
        firebaseRef?.removeAllObservers()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count < 10 ? players.count + 1 : 11
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath) as! RankingTableCell
        if indexPath.row == 0 {
            cell.username.text = "User"
            cell.rank.text = "Rank"
            cell.score.text = "Credits"
        }
        else{
            let selectedPlayer = self.players[indexPath.row - 1]
            self.players[indexPath.row - 1].rank = indexPath.row
            cell.username.text = selectedPlayer.name
            cell.rank.text = "\(indexPath.row)"
            cell.score.text = "\(selectedPlayer.score)"
        }
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0
        {
            let selectedPlayer = self.players[indexPath.row - 1]
            self.delegate?.playerSelected(newPlayer: selectedPlayer)
            
            if let detailViewController = self.delegate as? RankingDetailController {
                splitViewController?.showDetailViewController(detailViewController, sender: nil)
            }
        }
    }
    
}



