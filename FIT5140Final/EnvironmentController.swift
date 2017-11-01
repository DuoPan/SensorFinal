//
//  EnvironmentController.swift
//  FIT5140Final
//
//  Created by duo pan on 20/10/17.
//  Copyright © 2017 duo pan. All rights reserved.
//

import UIKit

class EnvironmentController: UITableViewController {

    var envData : EnvironmentData!
    var timerGetData:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        envData = EnvironmentData()
        timerGetData = Timer.scheduledTimer(timeInterval: TimeInterval(2), target:self,
                             selector:#selector(self.download),
                             userInfo:nil,repeats:true)
//        download()
    }

    func download()
    {
        var url: URL
        url = URL(string: "http://192.168.1.105:8080/temperature")!
        // fast method to get data
        guard let envJsonData = NSData(contentsOf: url) else { return }
        let jsonData = JSON(envJsonData)
        envData.temperature = jsonData["temperature"].int!;
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timerGetData.invalidate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "envCell", for: indexPath) as! EnvironmentCell
        cell.imageView?.image = #imageLiteral(resourceName: "icon_temp")
        // change image size later
//        let itemSize = CGSize(width:30.0, height:30.0)
//        UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
//        let imageRect = CGRect(x:0.0, y:0.0, width:itemSize.width, height:itemSize.height)
//        cell.imageView?.image!.draw(in:imageRect)
//        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        cell.attribute.text = "Temperature"
        cell.value.text = String(self.envData.temperature)
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
