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

class RankingTableController: UITableViewController {

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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        return players.count < 10 ? players.count : 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath) as! RankingTableCell
        
        let selectedPlayer = self.players[indexPath.row]
        cell.username.text = "\(indexPath.row)   " + selectedPlayer.name + "   \(selectedPlayer.score)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlayer = self.players[indexPath.row]
        self.delegate?.playerSelected(newPlayer: selectedPlayer)
        
        if let detailViewController = self.delegate as? RankingDetailController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    */

}
