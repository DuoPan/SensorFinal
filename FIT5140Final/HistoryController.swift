//
//  HistoryController.swift
//  FIT5140Final
//
//  Created by duo pan on 17/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit
// this class display all histories in one game
class HistoryController: UITableViewController {

    var historyList: [HistoryData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyList.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        if indexPath.row == 0 {
            cell.imageView?.image = #imageLiteral(resourceName: "icon_status")
            cell.number.text = "No"
            cell.name.text = "Event"
            cell.valueChange.text = "Score"
            cell.totalScore.text = "Total"
        }
        else{
            if(historyList[indexPath.row - 1].valueChange == 1){                
                cell.imageView?.image = #imageLiteral(resourceName: "icon_right")
            }
            else{
                cell.imageView?.image = #imageLiteral(resourceName: "icon_wrong")
            }
            cell.number.text = String(historyList[indexPath.row - 1].number)
            cell.name.text = historyList[indexPath.row - 1].name
            cell.valueChange.text = String(historyList[indexPath.row - 1].valueChange)
            cell.totalScore.text = String(historyList[indexPath.row - 1].totalScore)
        }
        

        return cell
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
